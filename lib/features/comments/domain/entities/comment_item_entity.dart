import 'package:tribe_up/features/comments/domain/entities/comment_permissions_entity.dart';

class CommentItemEntity {
  final String? userId;
  final String? username;
  final String? profilePicture;
  final int? id;
  final String? content;
  final String? createdAt;
  final int? postId;
  final bool? isAuthor;
  final bool? isLikedByCurrentUser;
  final int? likesCount;
  final CommentPermissionsEntity? permissions;

  const CommentItemEntity({
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

  CommentItemEntity copyWith({
    String? userId,
    String? username,
    String? profilePicture,
    int? id,
    String? content,
    String? createdAt,
    int? postId,
    bool? isAuthor,
    bool? isLikedByCurrentUser,
    int? likesCount,
    CommentPermissionsEntity? permissions,
  }) {
    return CommentItemEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      isAuthor: isAuthor ?? this.isAuthor,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      likesCount: likesCount ?? this.likesCount,
      permissions: permissions ?? this.permissions,
    );
  }

  static CommentItemEntity getDummyCommentItem() {
    return CommentItemEntity(
      userId: '1',
      username: 'John Doe',
      profilePicture:
          'https://ui-avatars.com/api/?name=John+Doe&background=random',
      id: 1,
      content: 'This is a comment',
      createdAt: '2022-01-01T00:00:00Z',
      postId: 1,
      isAuthor: true,
      isLikedByCurrentUser: false,
      likesCount: 0,
      permissions: CommentPermissionsEntity(
        canDelete: true,
        canEdit: true,
        canModerate: true,
      ),
    );
  }
}
