import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';
import 'package:tribe_up/features/story/data/models/story_model.dart';

abstract class StoryLocalDataSource {
  Future<void> cacheStoryFeed(List<StoryFeedItemModel> feed);
  Future<List<StoryFeedItemModel>> getCachedStoryFeed();
  Future<void> cacheGroupStories(int groupId, List<StoryModel> stories);
  Future<List<StoryModel>> getCachedGroupStories(int groupId);
  Future<void> markStoryAsViewedLocally(int storyId);
  Future<void> deleteStoryLocally(int storyId);
  Future<void> clearCache();
}
