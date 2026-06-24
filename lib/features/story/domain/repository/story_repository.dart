import 'dart:io';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';

abstract class StoryRepository {
  Future<BaseResponse<StoryEntity>> createStory({
    int? groupId,
    String? caption,
    required int accessibility,
    required File mediaFile,
  });

  Future<BaseResponse<bool>> deleteStory({required int storyId});

  Future<BaseResponse<List<StoryEntity>>> getGroupStories({
    required int groupId,
  });

  Future<BaseResponse<List<StoryFeedItemEntity>>> getStoryFeed({
    required int pageNumber,
    required int pageSize,
  });

  Future<BaseResponse<bool>> markAsViewed({required int storyId});
}
