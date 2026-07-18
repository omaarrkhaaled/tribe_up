import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/leaderboard_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@injectable
class GetLeaderboardUseCase {
  final GroupsRepository _repository;

  GetLeaderboardUseCase(this._repository);

  Future<BaseResponse<List<LeaderboardEntry>>> call(int top) {
    return _repository.getLeaderboard(top);
  }
}
