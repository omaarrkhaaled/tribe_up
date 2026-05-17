import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/data_sources/groups_data_source.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsDataSource _dataSource;
  GroupsRepositoryImpl(this._dataSource);
  @override
  Future<BaseResponse<GroupsResponse>> myGroups() async {
    final response = await _dataSource.myGroups();
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<Group>> getGroupById(int id) async {
    final response = await _dataSource.getGroupById(id);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<Group>> createGroup(
    String groupName,
    String description,
    String accessibility,
    File? profilePicture,
  ) async {
    final response = await _dataSource.createGroup(
      groupName,
      description,
      accessibility,
      profilePicture,
    );
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<Group>> updateGroup(
    int id,
    UpdateGroupRequest request,
  ) async {
    final response = await _dataSource.updateGroup(id, request);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updateGroupPicture(int id, File file) async {
    final response = await _dataSource.updateGroupPicture(id, file);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deleteGroup(int id) async {
    final response = await _dataSource.deleteGroup(id);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deleteGroupPicture(int id) async {
    final response = await _dataSource.deleteGroupPicture(id);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<GroupsResponse>> exploreGroups() async {
    final response = await _dataSource.exploreGroups();
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }
}
