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
  Future<GroupsResponse> myGroups();

  @GET(ApiConstants.getGroupByIdEndPoint)
  Future<Group> getGroupById(@Path("id") int id);

  @POST(ApiConstants.createGroupEndPoint)
  Future<Group> createGroup(
    @Query("groupName") String groupName,
    @Query("Description") String description,
    @Query("Accessibility") String accessibility,
    @Part(name: "ProfilePicture") File? profilePicture,
  );

  @PUT(ApiConstants.updateGroupEndPoint)
  Future<Group> updateGroup(
    @Path("id") int id,
    @Body() UpdateGroupRequest request,
  );

  @PUT(ApiConstants.updateGroupPictureEndPoint)
  Future<Group> updateGroupPicture(
    @Path("id") int id,
    @Part(name: "Picture") File file,
  );

  @DELETE(ApiConstants.deleteGroupEndPoint)
  Future<Group> deleteGroup(@Path("id") int id);

  @DELETE(ApiConstants.deleteGroupPictureEndPoint)
  Future<Group> deleteGroupPicture(@Path("id") int id);

  @GET(ApiConstants.exploreGroupsEndPoint)
  Future<GroupsResponse> exploreGroups();
}
