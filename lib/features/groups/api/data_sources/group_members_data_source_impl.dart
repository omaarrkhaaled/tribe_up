import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/groups/api/api_client/group_members_api_client.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_members_data_source.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

@Injectable(as: GroupMembersDataSource)
class GroupMembersDataSourceImpl implements GroupMembersDataSource {
  final GroupMembersApiClient _apiClient;
  GroupMembersDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<GroupMemberResultDTOPagedResult>> getGroupMembers(
    int groupId,
    int page,
    int pageSize,
    String? search,
  ) {
    return safeApiCall(
      () => _apiClient.getGroupMembers(groupId, page, pageSize, search),
    );
  }

  @override
  Future<BaseResponse<bool>> leaveGroup(int groupId) {
    return safeApiCall(() => _apiClient.leaveGroup(groupId));
  }

  @override
  Future<BaseResponse<bool>> promoteMember(int groupId, int groupMemberId) {
    return safeApiCall(() => _apiClient.promoteMember(groupId, groupMemberId));
  }

  @override
  Future<BaseResponse<bool>> demoteMember(int groupId, int groupMemberId) {
    return safeApiCall(() => _apiClient.demoteMember(groupId, groupMemberId));
  }

  @override
  Future<BaseResponse<bool>> kickMember(int groupId, int groupMemberId) {
    return safeApiCall(() => _apiClient.kickMember(groupId, groupMemberId));
  }
}
