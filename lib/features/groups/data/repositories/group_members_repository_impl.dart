import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_members_data_source.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_members_repository.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

@LazySingleton(as: GroupMembersRepository)
class GroupMembersRepositoryImpl implements GroupMembersRepository {
  final GroupMembersDataSource _dataSource;
  GroupMembersRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<GroupMemberResultDTOPagedResult>> getGroupMembers(
    int groupId,
    int page,
    int pageSize,
    String? search,
  ) async {
    final response = await _dataSource.getGroupMembers(
      groupId,
      page,
      pageSize,
      search,
    );
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> leaveGroup(int groupId) async {
    final response = await _dataSource.leaveGroup(groupId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> promoteMember(
    int groupId,
    int groupMemberId,
  ) async {
    final response = await _dataSource.promoteMember(groupId, groupMemberId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> demoteMember(
    int groupId,
    int groupMemberId,
  ) async {
    final response = await _dataSource.demoteMember(groupId, groupMemberId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> kickMember(int groupId, int groupMemberId) async {
    final response = await _dataSource.kickMember(groupId, groupMemberId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }
}
