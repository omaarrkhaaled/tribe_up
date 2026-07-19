import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/get_leaderboard_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_states.dart';

@injectable
class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboardUseCase _getLeaderboardUseCase;

  LeaderboardCubit(this._getLeaderboardUseCase)
    : super(const LeaderboardState());

  void doIntent(LeaderboardIntents intent) {
    switch (intent) {
      case LoadLeaderboardIntent(:final top):
        _loadLeaderboard(top);
    }
  }

  Future<void> _loadLeaderboard(int top) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final response = await _getLeaderboardUseCase(top);
    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(isLoading: false, entries: data));
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
    }
  }
}
