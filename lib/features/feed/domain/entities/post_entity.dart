import 'package:tribe_up/features/feed/data/models/media_model.dart';

class PostEntity {
  final int postId;
  final String? caption;
  final String userId;
  final String username;
  final int groupId;
  final String groupName;
  final String? groupProfilePicture;
  final int? likesCount;
  final int? commentCount;
  final bool isLikedByCurrentUser;
  final double? feedScore;
  final String createdAt;
  final List<MediaModel> media;
  final bool isDenied;
  final bool isAuthor;
  final bool canDelete;

  const PostEntity({
    required this.postId,
    required this.caption,
    required this.userId,
    required this.username,
    required this.groupId,
    required this.groupName,
    this.groupProfilePicture,
    this.likesCount,
    this.commentCount,
    required this.isLikedByCurrentUser,
    this.feedScore,
    required this.createdAt,
    required this.media,
    required this.isDenied,
    this.isAuthor = false,
    this.canDelete = false,
  });

  PostEntity copyWith({
    int? postId,
    String? caption,
    String? userId,
    String? username,
    int? groupId,
    String? groupName,
    String? groupProfilePicture,
    int? likesCount,
    int? commentCount,
    bool? isLikedByCurrentUser,
    double? feedScore,
    String? createdAt,
    List<MediaModel>? media,
    bool? isDenied,
    bool? isAuthor,
    bool? canDelete,
  }) {
    return PostEntity(
      postId: postId ?? this.postId,
      caption: caption ?? this.caption,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupProfilePicture: groupProfilePicture ?? this.groupProfilePicture,
      likesCount: likesCount ?? this.likesCount,
      commentCount: commentCount ?? this.commentCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      feedScore: feedScore ?? this.feedScore,
      createdAt: createdAt ?? this.createdAt,
      media: media ?? this.media,
      isDenied: isDenied ?? this.isDenied,
      isAuthor: isAuthor ?? this.isAuthor,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  static PostEntity getDummyPost() {
    return PostEntity(
      postId: 0,
      caption:
          'This is a dummy caption to simulate real text on the skeleton loader for testing purposes only.',
      userId: 'dummy',
      username: 'dummy_user',
      groupId: 0,
      groupName: 'Dummy Group Name',
      groupProfilePicture: 'https://picsum.photos/150',
      likesCount: 10,
      commentCount: 3,
      isLikedByCurrentUser: false,
      feedScore: 0,
      createdAt: DateTime.now().toIso8601String(),
      media: [
        MediaModel(
          id: 0,
          mediaURL: 'https://picsum.photos/400/250',
          mediaType: 'Image',
          order: 0,
        ),
      ],
      isDenied: false,
      isAuthor: false,
    );
  }
}
