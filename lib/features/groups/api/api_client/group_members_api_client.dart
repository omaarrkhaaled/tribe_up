import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

part 'group_members_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GroupMembersApiClient {
  @factoryMethod
  factory GroupMembersApiClient(Dio dio) = _GroupMembersApiClient;

  @GET(ApiConstants.groupMembersEndPoint)
  Future<GroupMemberResultDTOPagedResult> getGroupMembers(
    @Path("groupId") int groupId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("search") String? search,
  );

  @POST(ApiConstants.groupLeaveEndPoint)
  Future<bool> leaveGroup(@Path("groupId") int groupId);

  @POST(ApiConstants.groupPromoteMemberEndPoint)
  Future<bool> promoteMember(
    @Path("groupId") int groupId,
    @Path("GroupMemberId") int groupMemberId,
  );

  @POST(ApiConstants.groupDemoteMemberEndPoint)
  Future<bool> demoteMember(
    @Path("groupId") int groupId,
    @Path("GroupMemberId") int groupMemberId,
  );

  @POST(ApiConstants.groupKickMemberEndPoint)
  Future<bool> kickMember(
    @Path("groupId") int groupId,
    @Path("GroupMemberId") int groupMemberId,
  );
}
