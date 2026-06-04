import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/feed/data/models/media_model.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(name: 'postId')
  final int postId;
  @JsonKey(name: 'caption')
  final String? caption;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'groupName')
  final String groupName;
  @JsonKey(name: 'groupProfilePicture')
  final String groupProfilePicture;
  @JsonKey(name: 'likesCount')
  final int likesCount;
  @JsonKey(name: 'commentCount')
  final int commentCount;
  @JsonKey(name: 'isAuthor')
  final bool isAuthor;
  @JsonKey(name: 'isLikedByCurrentUser')
  final bool isLikedByCurrentUser;
  @JsonKey(name: 'feedScore')
  final double feedScore;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'media')
  final List<MediaModel> media;
  @JsonKey(name: 'postPermissions')
  final Map<String, dynamic> postPermissions;
  @JsonKey(name: 'isDenied')
  final bool isDenied;

  const PostModel({
    required this.postId,
    required this.caption,
    required this.userId,
    required this.username,
    required this.groupId,
    required this.groupName,
    required this.groupProfilePicture,
    required this.likesCount,
    required this.commentCount,
    required this.isAuthor,
    required this.isLikedByCurrentUser,
    required this.feedScore,
    required this.createdAt,
    required this.media,
    required this.postPermissions,
    required this.isDenied,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostEntity toEntity() {
    final canDelete = (postPermissions['canDelete'] as bool?) ?? isAuthor;
    return PostEntity(
      postId: postId,
      caption: caption,
      userId: userId,
      username: username,
      groupId: groupId,
      groupName: groupName,
      groupProfilePicture: groupProfilePicture,
      likesCount: likesCount,
      commentCount: commentCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      feedScore: feedScore,
      createdAt: createdAt,
      media: media,
      isDenied: isDenied,
      isAuthor: isAuthor,
      canDelete: canDelete,
    );
  }
}
