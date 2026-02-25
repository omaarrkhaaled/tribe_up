import 'package:json_annotation/json_annotation.dart';
part 'group_permissions.g.dart';

@JsonSerializable()
class PostPermission {
  @JsonKey(name: 'canFollow')
  final bool canFollow;
  @JsonKey(name: 'canJoin')
  final bool canJoin;
  @JsonKey(name: 'canPost')
  final bool canPost;
  @JsonKey(name: 'canCreatePoll')
  final bool canCreatePoll;
  @JsonKey(name: 'canCreateEvent')
  final bool canCreateEvent;
  @JsonKey(name: 'canDeletePost')
  final bool canDeletePost;
  @JsonKey(name: 'canModerate')
  final bool canModerate;
  @JsonKey(name: 'canEditGroup')
  final bool canEditGroup;
  @JsonKey(name: 'canDeleteGroup')
  final bool canDeleteGroup;

  const PostPermission({
    required this.canFollow,
    required this.canJoin,
    required this.canPost,
    required this.canCreatePoll,
    required this.canCreateEvent,
    required this.canDeletePost,
    required this.canModerate,
    required this.canEditGroup,
    required this.canDeleteGroup,
  });

  factory PostPermission.fromJson(Map<String, dynamic> json) =>
      _$PostPermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PostPermissionToJson(this);
}
