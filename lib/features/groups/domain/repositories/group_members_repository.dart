import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

abstract class GroupMembersRepository {
  Future<BaseResponse<GroupMemberResultDTOPagedResult>> getGroupMembers(
    int groupId,
    int page,
    int pageSize,
    String? search,
  );
  Future<BaseResponse<bool>> leaveGroup(int groupId);
  Future<BaseResponse<bool>> promoteMember(int groupId, int groupMemberId);
  Future<BaseResponse<bool>> demoteMember(int groupId, int groupMemberId);
  Future<BaseResponse<bool>> kickMember(int groupId, int groupMemberId);
}
