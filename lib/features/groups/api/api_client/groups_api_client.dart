import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

part 'groups_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GroupsApiClient {
  @factoryMethod
  factory GroupsApiClient(Dio dio) = _GroupsApiClient;

  @GET(ApiConstants.myGroupsEndPoint)
  Future<GroupsResponse> myGroups(
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  );

  @GET(ApiConstants.getGroupByIdEndPoint)
  Future<Group> getGroupById(@Path("id") int id);

  @POST(ApiConstants.createGroupEndPoint)
  Future<Group> createGroup(
    @Query("groupName") String groupName,
    @Query("Description") String description,
    @Query("Accessibility") String accessibility,
    @Part(name: "GroupProfilePicture") File? profilePicture,
  );

  @PUT(ApiConstants.updateGroupEndPoint)
  Future<Group> updateGroup(
    @Path("Id") int id,
    @Body() UpdateGroupRequest request,
  );

  @PUT(ApiConstants.updateGroupPictureEndPoint)
  Future<Group> updateGroupPicture(
    @Path("Id") int id,
    @Part(name: "Picture") File file,
  );

  @DELETE(ApiConstants.deleteGroupEndPoint)
  Future<Group> deleteGroup(@Path("Id") int id);

  @DELETE(ApiConstants.deleteGroupPictureEndPoint)
  Future<Group> deleteGroupPicture(@Path("Id") int id);

  @GET(ApiConstants.exploreGroupsEndPoint)
  Future<GroupsResponse> exploreGroups(
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
    @Query("search") String? search,
  );
}
