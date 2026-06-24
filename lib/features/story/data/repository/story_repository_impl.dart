import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/story/data/data_sources/story_remote_data_source.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@Injectable(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource _remoteDataSource;

  const StoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<StoryEntity>> createStory({
    int? groupId,
    String? caption,
    required int accessibility,
    required File mediaFile,
  }) {
    return safeApiCall<StoryEntity>(() async {
      final model = await _remoteDataSource.createStory(
        groupId: groupId,
        caption: caption,
        accessibility: accessibility,
        mediaFile: mediaFile,
      );
      return model.toEntity();
    });
  }

  @override
  Future<BaseResponse<bool>> deleteStory({required int storyId}) {
    return safeApiCall<bool>(() async {
      await _remoteDataSource.deleteStory(storyId: storyId);
      return true;
    });
  }

  @override
  Future<BaseResponse<List<StoryEntity>>> getGroupStories({
    required int groupId,
  }) {
    return safeApiCall<List<StoryEntity>>(() async {
      final list = await _remoteDataSource.getGroupStories(groupId: groupId);
      return list.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<List<StoryFeedItemEntity>>> getStoryFeed({
    required int pageNumber,
    required int pageSize,
  }) {
    return safeApiCall<List<StoryFeedItemEntity>>(() async {
      final list = await _remoteDataSource.getStoryFeed(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return list.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<bool>> markAsViewed({required int storyId}) {
    return safeApiCall<bool>(() async {
      await _remoteDataSource.markAsViewed(storyId: storyId);
      return true;
    });
  }
}
