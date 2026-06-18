import 'package:json_annotation/json_annotation.dart';

part 'groups_response.g.dart';

@JsonSerializable()
class GroupsResponse {
  @JsonKey(name: 'items')
  final List<Group>? items;
  @JsonKey(name: 'page')
  final int? page;
  @JsonKey(name: 'pageSize')
  final int? pageSize;
  @JsonKey(name: 'totalCount')
  final int? totalCount;
  @JsonKey(name: 'hasMore')
  final bool? hasMore;

  GroupsResponse({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });

  factory GroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupsResponseToJson(this);
}

@JsonSerializable()
class Group {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'groupName')
  final String? groupName;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'groupProfilePicture')
  final String? groupProfilePicture;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'accessibility')
  final int? accessibility;
  @JsonKey(name: 'userRelation')
  final int? userRelation;
  @JsonKey(name: 'membersCount')
  final int? membersCount;

  Group({
    this.id,
    this.groupName,
    this.description,
    this.groupProfilePicture,
    this.createdAt,
    this.accessibility,
    this.userRelation,
    this.membersCount,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
