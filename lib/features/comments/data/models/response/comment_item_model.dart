import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_permissions_entity.dart';

part 'comment_item_model.g.dart';

@JsonSerializable()
class CommentItemModel {
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'postId')
  final int? postId;
  @JsonKey(name: 'isAuthor')
  final bool? isAuthor;
  @JsonKey(name: 'isLikedByCurrentUser')
  final bool? isLikedByCurrentUser;
  @JsonKey(name: 'likesCount')
  final int? likesCount;
  @JsonKey(name: 'permissions')
  final CommentPermissionsModel? permissions;

  const CommentItemModel({
    this.userId,
    this.username,
    this.profilePicture,
    this.id,
    this.content,
    this.createdAt,
    this.postId,
    this.isAuthor,
    this.isLikedByCurrentUser,
    this.likesCount,
    this.permissions,
  });

  factory CommentItemModel.fromJson(Map<String, dynamic> json) =>
      _$CommentItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentItemModelToJson(this);

  CommentItemEntity toEntity() {
    return CommentItemEntity(
      userId: userId,
      username: username,
      profilePicture: profilePicture,
      id: id,
      content: content,
      createdAt: createdAt,
      postId: postId,
      isAuthor: isAuthor,
      isLikedByCurrentUser: isLikedByCurrentUser,
      likesCount: likesCount,
      permissions: permissions?.toEntity(),
    );
  }
}

@JsonSerializable()
class CommentPermissionsModel {
  @JsonKey(name: 'canDelete')
  final bool? canDelete;
  @JsonKey(name: 'canEdit')
  final bool? canEdit;
  @JsonKey(name: 'canModerate')
  final bool? canModerate;

  CommentPermissionsModel({this.canDelete, this.canEdit, this.canModerate});

  factory CommentPermissionsModel.fromJson(Map<String, dynamic> json) =>
      _$CommentPermissionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentPermissionsModelToJson(this);

  CommentPermissionsEntity toEntity() {
    return CommentPermissionsEntity(
      canDelete: canDelete,
      canEdit: canEdit,
      canModerate: canModerate,
    );
  }
}
