import 'package:json_annotation/json_annotation.dart';

part 'group_members_response.g.dart';

@JsonSerializable()
class GroupMemberResultDTO {
  final int? id;
  final String? userId;
  final String? userName;
  final String? userProfilePicture;
  final String? role;
  final String? joinedAt;

  GroupMemberResultDTO({
    this.id,
    this.userId,
    this.userName,
    this.userProfilePicture,
    this.role,
    this.joinedAt,
  });

  factory GroupMemberResultDTO.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberResultDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberResultDTOToJson(this);
}

@JsonSerializable()
class GroupMemberResultDTOPagedResult {
  final List<GroupMemberResultDTO>? items;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final bool? hasMore;

  GroupMemberResultDTOPagedResult({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });

  factory GroupMemberResultDTOPagedResult.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberResultDTOPagedResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GroupMemberResultDTOPagedResultToJson(this);
}
