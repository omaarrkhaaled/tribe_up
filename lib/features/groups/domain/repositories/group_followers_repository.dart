import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';

abstract class GroupFollowersRepository {
  Future<BaseResponse<GroupFollowerResultDTOPagedResult>> getFollowers(
    int groupId,
    int page,
    int pageSize,
    String? searchTerm,
  );
  Future<BaseResponse<FollowActionResponseDTO>> toggleFollow(int groupId);
  Future<BaseResponse<bool>> deleteFollower(int groupId, String followerId);
}
