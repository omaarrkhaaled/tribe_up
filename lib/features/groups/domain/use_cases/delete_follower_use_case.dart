import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_followers_repository.dart';

@lazySingleton
class DeleteFollowerUseCase {
  final GroupFollowersRepository repository;
  DeleteFollowerUseCase(this.repository);

  Future<BaseResponse<bool>> call(int groupId, String followerId) async {
    return await repository.deleteFollower(groupId, followerId);
  }
}
