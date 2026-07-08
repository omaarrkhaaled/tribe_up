import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/data_sources/polls_data_source.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@LazySingleton(as: PollsRepository)
class PollsRepositoryImpl implements PollsRepository {
  final PollsDataSource _dataSource;

  PollsRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<Poll>> createPoll(
    int groupId,
    CreatePollRequest request,
  ) async {
    final response = await _dataSource.createPoll(groupId, request);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<PollsPagedResult>> getGroupPolls(
    int groupId,
    int? page,
    int? pageSize,
  ) async {
    final response = await _dataSource.getGroupPolls(groupId, page, pageSize);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<Poll>> getPollById(int pollId) async {
    final response = await _dataSource.getPollById(pollId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<Poll>> updatePoll(
    int pollId,
    EditPollRequest request,
  ) async {
    final response = await _dataSource.updatePoll(pollId, request);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deletePoll(int pollId) async {
    final response = await _dataSource.deletePoll(pollId);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<ToggleVoteResult>> toggleVote(
    int pollId,
    int optionId,
  ) async {
    final response = await _dataSource.toggleVote(pollId, optionId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }
}
