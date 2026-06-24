class StoryEntity {
  final int id;
  final String? caption;
  final String? mediaURL;
  final String createdAt;
  final String? expiresAt;
  final int viewsCount;
  final String? creatorId;
  final String? creatorUserName;
  final String? groupProfilePicture;
  final bool isViewedByCurrentUser;

  const StoryEntity({
    required this.id,
    this.caption,
    this.mediaURL,
    required this.createdAt,
    this.expiresAt,
    required this.viewsCount,
    this.creatorId,
    this.creatorUserName,
    this.groupProfilePicture,
    required this.isViewedByCurrentUser,
  });
}
