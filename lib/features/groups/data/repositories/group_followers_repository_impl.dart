import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_followers_data_source.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_followers_repository.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';

@LazySingleton(as: GroupFollowersRepository)
class GroupFollowersRepositoryImpl implements GroupFollowersRepository {
  final GroupFollowersDataSource _dataSource;
  GroupFollowersRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<GroupFollowerResultDTOPagedResult>> getFollowers(
    int groupId,
    int page,
    int pageSize,
    String? searchTerm,
  ) async {
    final response = await _dataSource.getFollowers(
      groupId,
      page,
      pageSize,
      searchTerm,
    );
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<FollowActionResponseDTO>> toggleFollow(
    int groupId,
  ) async {
    final response = await _dataSource.toggleFollow(groupId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> deleteFollower(
    int groupId,
    String followerId,
  ) async {
    final response = await _dataSource.deleteFollower(groupId, followerId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }
}
