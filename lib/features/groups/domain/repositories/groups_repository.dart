import 'dart:io';

import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/data/models/response/leaderboard_response.dart';

abstract class GroupsRepository {
  Future<BaseResponse<GroupsResponse>> myGroups(int? page, int? pageSize);
  Future<BaseResponse<Group>> getGroupById(int id);
  Future<BaseResponse<Group>> createGroup(
    String groupName,
    String description,
    String accessibility,
    File? profilePicture,
  );
  Future<BaseResponse<Group>> updateGroup(int id, UpdateGroupRequest request);
  Future<BaseResponse<void>> updateGroupPicture(int id, File file);
  Future<BaseResponse<void>> deleteGroup(int id);
  Future<BaseResponse<void>> deleteGroupPicture(int id);
  Future<BaseResponse<GroupsResponse>> exploreGroups(
    int? page,
    int? pageSize,
    String? search,
  );
  Future<BaseResponse<GroupsResponse>> followedGroups(int? page, int? pageSize);
  Future<BaseResponse<List<LeaderboardEntry>>> getLeaderboard(int top);
}
