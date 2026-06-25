import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/story/data/data_sources/story_local_data_source.dart';
import 'package:tribe_up/features/story/data/data_sources/story_remote_data_source.dart';
import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@Injectable(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource _remoteDataSource;
  final StoryLocalDataSource _localDataSource;

  const StoryRepositoryImpl(this._remoteDataSource, this._localDataSource);

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

      if (groupId != null) {
        // Update group stories cache
        final cachedStories = await _localDataSource.getCachedGroupStories(
          groupId,
        );
        cachedStories.add(model);
        await _localDataSource.cacheGroupStories(groupId, cachedStories);

        // Update story feed cache
        final feedItems = await _localDataSource.getCachedStoryFeed();
        final feedIndex = feedItems.indexWhere(
          (item) => item.groupId == groupId,
        );

        final groupName = model.creatorUserName;
        final groupPic = model.groupProfilePicture;

        if (feedIndex != -1) {
          final oldItem = feedItems[feedIndex];
          feedItems[feedIndex] = StoryFeedItemModel(
            groupId: oldItem.groupId,
            groupName: oldItem.groupName ?? groupName,
            groupProfilePicture: oldItem.groupProfilePicture ?? groupPic,
            hasUnseenStories: true,
            latestStoryDate: model.createdAt,
          );
        } else {
          feedItems.insert(
            0,
            StoryFeedItemModel(
              groupId: groupId,
              groupName: groupName,
              groupProfilePicture: groupPic,
              hasUnseenStories: true,
              latestStoryDate: model.createdAt,
            ),
          );
        }
        await _localDataSource.cacheStoryFeed(feedItems);
      }

      return model.toEntity();
    });
  }

  @override
  Future<BaseResponse<bool>> deleteStory({required int storyId}) {
    return safeApiCall<bool>(() async {
      // Revert/delete locally first for instant UI response
      await _localDataSource.deleteStoryLocally(storyId);
      await _remoteDataSource.deleteStory(storyId: storyId);

      return true;
    });
  }

  @override
  Future<BaseResponse<List<StoryEntity>>> getGroupStories({
    required int groupId,
  }) {
    return safeApiCall<List<StoryEntity>>(() async {
      try {
        final list = await _remoteDataSource.getGroupStories(groupId: groupId);
        await _localDataSource.cacheGroupStories(groupId, list);
        return list.map((m) => m.toEntity()).toList();
      } catch (e) {
        final cached = await _localDataSource.getCachedGroupStories(groupId);
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
        rethrow;
      }
    });
  }

  @override
  Future<BaseResponse<List<StoryFeedItemEntity>>> getStoryFeed({
    required int pageNumber,
    required int pageSize,
  }) {
    return safeApiCall<List<StoryFeedItemEntity>>(() async {
      try {
        final list = await _remoteDataSource.getStoryFeed(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        await _localDataSource.cacheStoryFeed(list);
        return list.map((m) => m.toEntity()).toList();
      } catch (e) {
        final cached = await _localDataSource.getCachedStoryFeed();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
        rethrow;
      }
    });
  }

  @override
  Future<BaseResponse<bool>> markAsViewed({required int storyId}) {
    return safeApiCall<bool>(() async {
      // Mark viewed locally first (instant UI feedback)
      await _localDataSource.markStoryAsViewedLocally(storyId);
      await _remoteDataSource.markAsViewed(storyId: storyId);

      return true;
    });
  }
}
