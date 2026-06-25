import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';

class StoryState extends Equatable {
  final bool isLoadingFeed;
  final List<StoryFeedItemEntity> storyFeedItems;
  final Map<int, List<StoryEntity>> groupStories;
  final Map<int, bool> isLoadingGroupStories;
  final String? errorMessage;

  const StoryState({
    this.isLoadingFeed = false,
    this.storyFeedItems = const [],
    this.groupStories = const {},
    this.isLoadingGroupStories = const {},
    this.errorMessage,
  });

  StoryState copyWith({
    bool? isLoadingFeed,
    List<StoryFeedItemEntity>? storyFeedItems,
    Map<int, List<StoryEntity>>? groupStories,
    Map<int, bool>? isLoadingGroupStories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StoryState(
      isLoadingFeed: isLoadingFeed ?? this.isLoadingFeed,
      storyFeedItems: storyFeedItems ?? this.storyFeedItems,
      groupStories: groupStories ?? this.groupStories,
      isLoadingGroupStories:
          isLoadingGroupStories ?? this.isLoadingGroupStories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoadingFeed,
    storyFeedItems,
    groupStories,
    isLoadingGroupStories,
    errorMessage,
  ];
}
