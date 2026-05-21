import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/groups/api/api_client/group_followers_api_client.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_followers_data_source.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';

@Injectable(as: GroupFollowersDataSource)
class GroupFollowersDataSourceImpl implements GroupFollowersDataSource {
  final GroupFollowersApiClient _apiClient;
  GroupFollowersDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<GroupFollowerResultDTOPagedResult>> getFollowers(
    int groupId,
    int page,
    int pageSize,
    String? searchTerm,
  ) {
    return safeApiCall(
      () => _apiClient.getFollowers(groupId, page, pageSize, searchTerm),
    );
  }

  @override
  Future<BaseResponse<FollowActionResponseDTO>> toggleFollow(int groupId) {
    return safeApiCall(() => _apiClient.toggleFollow(groupId));
  }

  @override
  Future<BaseResponse<bool>> deleteFollower(int groupId, String followerId) {
    return safeApiCall(() => _apiClient.deleteFollower(groupId, followerId));
  }
}
