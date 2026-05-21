import 'package:json_annotation/json_annotation.dart';

part 'group_followers_response.g.dart';

@JsonSerializable()
class GroupFollowerResultDTO {
  final String? userId;
  final String? userName;
  final String? profilePictureUrl;
  final String? followedAt;

  GroupFollowerResultDTO({
    this.userId,
    this.userName,
    this.profilePictureUrl,
    this.followedAt,
  });

  factory GroupFollowerResultDTO.fromJson(Map<String, dynamic> json) =>
      _$GroupFollowerResultDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GroupFollowerResultDTOToJson(this);
}

@JsonSerializable()
class GroupFollowerResultDTOPagedResult {
  final List<GroupFollowerResultDTO>? items;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final bool? hasMore;

  GroupFollowerResultDTOPagedResult({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });

  factory GroupFollowerResultDTOPagedResult.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupFollowerResultDTOPagedResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GroupFollowerResultDTOPagedResultToJson(this);
}

@JsonSerializable()
class FollowActionResponseDTO {
  final String? message;
  final int? currentRelation; // Enum GroupRelationType mapped as int

  FollowActionResponseDTO({this.message, this.currentRelation});

  factory FollowActionResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$FollowActionResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FollowActionResponseDTOToJson(this);
}
