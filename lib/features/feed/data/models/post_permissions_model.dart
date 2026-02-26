import 'package:json_annotation/json_annotation.dart';
part 'post_permissions_model.g.dart';

@JsonSerializable()
class PostsPermission {
  @JsonKey(name: 'canDelete')
  final bool canDeletePost;
  @JsonKey(name: 'canModerate')
  final bool canModerate;

  const PostsPermission({
    required this.canDeletePost,
    required this.canModerate,
  });

  factory PostsPermission.fromJson(Map<String, dynamic> json) =>
      _$PostsPermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PostsPermissionToJson(this);
}
