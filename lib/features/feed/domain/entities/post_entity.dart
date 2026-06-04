import 'package:tribe_up/features/feed/data/models/media_model.dart';

class PostEntity {
  final int postId;
  final String? caption;
  final String userId;
  final String username;
  final int groupId;
  final String groupName;
  final String groupProfilePicture;
  final int likesCount;
  final int commentCount;
  final bool isLikedByCurrentUser;
  final double feedScore;
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
    required this.groupProfilePicture,
    required this.likesCount,
    required this.commentCount,
    required this.isLikedByCurrentUser,
    required this.feedScore,
    required this.createdAt,
    required this.media,
    required this.isDenied,
    this.isAuthor = false,
    this.canDelete = false,
  });

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
