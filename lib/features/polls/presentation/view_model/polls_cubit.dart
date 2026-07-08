import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/use_cases/create_poll_use_case.dart';
import 'package:tribe_up/features/polls/domain/use_cases/get_group_polls_use_case.dart';
import 'package:tribe_up/features/polls/domain/use_cases/get_poll_by_id_use_case.dart';
import 'package:tribe_up/features/polls/domain/use_cases/update_poll_use_case.dart';
import 'package:tribe_up/features/polls/domain/use_cases/delete_poll_use_case.dart';
import 'package:tribe_up/features/polls/domain/use_cases/toggle_vote_use_case.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_intents.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_states.dart';
import 'package:tribe_up/features/polls/presentation/view_model/polls_ui_intents.dart';

@injectable
class PollsCubit extends Cubit<PollsState> {
  final CreatePollUseCase _createPollUseCase;
  final GetGroupPollsUseCase _getGroupPollsUseCase;
  final GetPollByIdUseCase _getPollByIdUseCase;
  final UpdatePollUseCase _updatePollUseCase;
  final DeletePollUseCase _deletePollUseCase;
  final ToggleVoteUseCase _toggleVoteUseCase;

  final StreamController<PollsUiIntents> _uiController =
      StreamController.broadcast();
  Stream<PollsUiIntents> get uiIntents => _uiController.stream;

  PollsCubit(
    this._createPollUseCase,
    this._getGroupPollsUseCase,
    this._getPollByIdUseCase,
    this._updatePollUseCase,
    this._deletePollUseCase,
    this._toggleVoteUseCase,
  ) : super(const PollsState());

  void doIntent(PollsIntents intent) {
    switch (intent) {
      case LoadPollsIntent(:final groupId, :final isRefresh):
        _loadPolls(groupId, isRefresh);
      case LoadMorePollsIntent(:final groupId):
        _loadMorePolls(groupId);
      case CreatePollIntent(:final groupId, :final request):
        _createPoll(groupId, request);
      case UpdatePollIntent(:final pollId, :final request):
        _updatePoll(pollId, request);
      case DeletePollIntent(:final pollId):
        _deletePoll(pollId);
      case ToggleVoteIntent(:final pollId, :final optionId):
        _toggleVote(pollId, optionId);
      case RefreshPollByIdIntent(:final pollId):
        _refreshPollById(pollId);
    }
  }

  Future<void> _loadPolls(int groupId, bool isRefresh) async {
    emit(state.copyWith(isLoading: !isRefresh, clearError: true));
    final response = await _getGroupPollsUseCase(
      groupId: groupId,
      page: 1,
      pageSize: 10,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            polls: data.items ?? [],
            hasMore: data.hasMore ?? false,
            page: 1,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadMorePolls(int groupId) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.page + 1;
    final response = await _getGroupPollsUseCase(
      groupId: groupId,
      page: nextPage,
      pageSize: 10,
    );
    switch (response) {
      case SuccessResponse(:final data):
        final List<Poll> updatedList = List.from(state.polls)
          ..addAll(data.items ?? []);
        emit(
          state.copyWith(
            isLoadingMore: false,
            polls: updatedList,
            hasMore: data.hasMore ?? false,
            page: nextPage,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoadingMore: false));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _createPoll(int groupId, CreatePollRequest request) async {
    emit(state.copyWith(isActionLoading: true));
    final response = await _createPollUseCase(
      groupId: groupId,
      request: request,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(isActionLoading: false, polls: [data, ...state.polls]),
        );
        _uiController.add(ShowSuccessUiIntent("Poll created successfully!"));
        _uiController.add(PollCreatedUiIntent(data));
      case ErrorResponse(:final error):
        emit(state.copyWith(isActionLoading: false));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _updatePoll(int pollId, EditPollRequest request) async {
    emit(state.copyWith(isActionLoading: true));
    final response = await _updatePollUseCase(pollId: pollId, request: request);
    switch (response) {
      case SuccessResponse(:final data):
        final updatedPolls = state.polls
            .map((p) => p.pollId == pollId ? data : p)
            .toList();
        emit(state.copyWith(isActionLoading: false, polls: updatedPolls));
        _uiController.add(ShowSuccessUiIntent("Poll updated successfully!"));
        _uiController.add(PollUpdatedUiIntent(data));
      case ErrorResponse(:final error):
        emit(state.copyWith(isActionLoading: false));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _deletePoll(int pollId) async {
    emit(state.copyWith(isActionLoading: true));
    final response = await _deletePollUseCase(pollId: pollId);
    switch (response) {
      case SuccessResponse():
        final updatedPolls = state.polls
            .where((p) => p.pollId != pollId)
            .toList();
        emit(state.copyWith(isActionLoading: false, polls: updatedPolls));
        _uiController.add(ShowSuccessUiIntent("Poll deleted successfully!"));
        _uiController.add(const PollDeletedUiIntent());
      case ErrorResponse(:final error):
        emit(state.copyWith(isActionLoading: false));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _toggleVote(int pollId, int optionId) async {
    final originalPolls = state.polls;
    final targetPoll = state.polls.firstWhere((p) => p.pollId == pollId);

    final updatedOptions = targetPoll.options?.map((opt) {
      bool isSelected = opt.optionId == optionId;
      bool wasVoted = opt.isVotedByCurrentUser ?? false;
      int currentVotes = opt.votesCount ?? 0;

      if (targetPoll.allowMultipleAnswers == true) {
        if (isSelected) {
          bool nextVoted = !wasVoted;
          int nextVotes = nextVoted
              ? currentVotes + 1
              : (currentVotes - 1).clamp(0, 999999);
          return _copyOptionWithVotes(opt, nextVoted, nextVotes);
        }
        return opt;
      } else {
        if (isSelected) {
          bool nextVoted = !wasVoted;
          int nextVotes = nextVoted
              ? currentVotes + 1
              : (currentVotes - 1).clamp(0, 999999);
          return _copyOptionWithVotes(opt, nextVoted, nextVotes);
        } else if (wasVoted) {
          return _copyOptionWithVotes(
            opt,
            false,
            (currentVotes - 1).clamp(0, 999999),
          );
        }
        return opt;
      }
    }).toList();

    final int newTotalUniqueVoters = targetPoll.allowMultipleAnswers == true
        ? _estimateMultiVoters(updatedOptions ?? [])
        : (updatedOptions?.fold<int>(
                0,
                (sum, item) => sum + (item.votesCount ?? 0),
              ) ??
              0);

    final finalOptions = updatedOptions?.map((opt) {
      double pct = newTotalUniqueVoters > 0
          ? ((opt.votesCount ?? 0) / newTotalUniqueVoters) * 100.0
          : 0.0;
      return _copyOptionWithPct(opt, pct);
    }).toList();

    final updatedPoll = _copyPollWithOptions(
      targetPoll,
      finalOptions ?? [],
      newTotalUniqueVoters,
    );
    final optimisticPolls = state.polls
        .map((p) => p.pollId == pollId ? updatedPoll : p)
        .toList();
    emit(state.copyWith(polls: optimisticPolls));

    final response = await _toggleVoteUseCase(
      pollId: pollId,
      optionId: optionId,
    );
    switch (response) {
      case SuccessResponse():
        _refreshPollById(pollId);
      case ErrorResponse(:final error):
        emit(state.copyWith(polls: originalPolls));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  PollOption _copyOptionWithVotes(PollOption opt, bool isVoted, int votes) {
    return PollOption(
      optionId: opt.optionId,
      optionText: opt.optionText,
      votesCount: votes,
      percentage: opt.percentage,
      isVotedByCurrentUser: isVoted,
      voters: opt.voters,
    );
  }

  PollOption _copyOptionWithPct(PollOption opt, double pct) {
    return PollOption(
      optionId: opt.optionId,
      optionText: opt.optionText,
      votesCount: opt.votesCount,
      percentage: pct,
      isVotedByCurrentUser: opt.isVotedByCurrentUser,
      voters: opt.voters,
    );
  }

  Poll _copyPollWithOptions(Poll p, List<PollOption> opts, int totalVoters) {
    return Poll(
      pollId: p.pollId,
      question: p.question,
      createdAt: p.createdAt,
      expiresAt: p.expiresAt,
      createdByUserName: p.createdByUserName,
      totalUniqueVoters: totalVoters,
      isExpired: p.isExpired,
      allowMultipleAnswers: p.allowMultipleAnswers,
      options: opts,
    );
  }

  int _estimateMultiVoters(List<PollOption> opts) {
    int totalOptionVotes = opts.fold<int>(
      0,
      (sum, o) => sum + (o.votesCount ?? 0),
    );
    return totalOptionVotes;
  }

  Future<void> _refreshPollById(int pollId) async {
    final response = await _getPollByIdUseCase(pollId: pollId);
    if (response is SuccessResponse<Poll>) {
      final updatedPolls = state.polls
          .map((p) => p.pollId == pollId ? response.data : p)
          .toList();
      emit(state.copyWith(polls: updatedPolls));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
