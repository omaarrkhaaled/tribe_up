import 'dart:io';
import 'package:tribe_up/features/story/data/models/story_model.dart';
import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';

abstract class StoryRemoteDataSource {
  Future<StoryModel> createStory({
    int? groupId,
    String? caption,
    required int accessibility,
    required File mediaFile,
  });

  Future<void> deleteStory({required int storyId});

  Future<List<StoryModel>> getGroupStories({required int groupId});

  Future<List<StoryFeedItemModel>> getStoryFeed({
    required int pageNumber,
    required int pageSize,
  });

  Future<void> markAsViewed({required int storyId});
}
