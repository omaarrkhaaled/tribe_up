import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/story/api/api_client/story_api_client.dart';
import 'package:tribe_up/features/story/data/data_sources/story_remote_data_source.dart';
import 'package:tribe_up/features/story/data/models/story_model.dart';
import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';

@Injectable(as: StoryRemoteDataSource)
class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final StoryApiClient _apiClient;

  const StoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StoryModel> createStory({
    int? groupId,
    String? caption,
    required int accessibility,
    required File mediaFile,
  }) async {
    return await _apiClient.createStory(
      groupId,
      caption,
      accessibility,
      mediaFile,
    );
  }

  @override
  Future<void> deleteStory({required int storyId}) async {
    await _apiClient.deleteStory(storyId);
  }

  @override
  Future<List<StoryModel>> getGroupStories({required int groupId}) async {
    return await _apiClient.getGroupStories(groupId);
  }

  @override
  Future<List<StoryFeedItemModel>> getStoryFeed({
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _apiClient.getStoryFeed(pageNumber, pageSize);
  }

  @override
  Future<void> markAsViewed({required int storyId}) async {
    await _apiClient.markAsViewed(storyId);
  }
}
