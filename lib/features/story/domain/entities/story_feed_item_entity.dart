class StoryFeedItemEntity {
  final int groupId;
  final String? groupName;
  final String? groupProfilePicture;
  final bool hasUnseenStories;
  final String latestStoryDate;

  const StoryFeedItemEntity({
    required this.groupId,
    this.groupName,
    this.groupProfilePicture,
    required this.hasUnseenStories,
    required this.latestStoryDate,
  });
}
