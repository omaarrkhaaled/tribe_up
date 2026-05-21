import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_followers_repository.dart';

@lazySingleton
class ToggleFollowUseCase {
  final GroupFollowersRepository repository;
  ToggleFollowUseCase(this.repository);

  Future<BaseResponse<FollowActionResponseDTO>> call(int groupId) async {
    return await repository.toggleFollow(groupId);
  }
}
