import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/groups/api/api_client/groups_api_client.dart';
import 'package:tribe_up/features/groups/data/data_sources/groups_data_source.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

@Injectable(as: GroupsDataSource)
class GroupsDataSourceImpl implements GroupsDataSource {
  final GroupsApiClient _apiClient;
  GroupsDataSourceImpl(this._apiClient);
  @override
  Future<BaseResponse<GroupsResponse>> myGroups(int? page, int? pageSize) {
    return safeApiCall(() => _apiClient.myGroups(page, pageSize));
  }

  @override
  Future<BaseResponse<Group>> getGroupById(int id) {
    return safeApiCall(() => _apiClient.getGroupById(id));
  }

  @override
  Future<BaseResponse<Group>> createGroup(
    String groupName,
    String description,
    String accessibility,
    File? profilePicture,
  ) {
    return safeApiCall(
      () => _apiClient.createGroup(
        groupName,
        description,
        accessibility,
        profilePicture,
      ),
    );
  }

  @override
  Future<BaseResponse<Group>> updateGroup(int id, UpdateGroupRequest request) {
    return safeApiCall(() => _apiClient.updateGroup(id, request));
  }

  @override
  Future<BaseResponse<dynamic>> updateGroupPicture(int id, File file) {
    return safeApiCall(() => _apiClient.updateGroupPicture(id, file));
  }

  @override
  Future<BaseResponse<dynamic>> deleteGroup(int id) {
    return safeApiCall(() => _apiClient.deleteGroup(id));
  }

  @override
  Future<BaseResponse<dynamic>> deleteGroupPicture(int id) {
    return safeApiCall(() => _apiClient.deleteGroupPicture(id));
  }

  @override
  Future<BaseResponse<GroupsResponse>> exploreGroups(
    int? page,
    int? pageSize,
    String? search,
  ) {
    return safeApiCall(() => _apiClient.exploreGroups(page, pageSize, search));
  }
}
