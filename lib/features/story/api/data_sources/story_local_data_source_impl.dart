import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/story/data/data_sources/story_local_data_source.dart';
import 'package:tribe_up/features/story/data/models/story_feed_item_model.dart';
import 'package:tribe_up/features/story/data/models/story_model.dart';

@Injectable(as: StoryLocalDataSource)
class StoryLocalDataSourceImpl implements StoryLocalDataSource {
  final Box<String> _box;

  StoryLocalDataSourceImpl(@Named(CacheConstants.storiesBoxName) this._box);

  @override
  Future<void> cacheStoryFeed(List<StoryFeedItemModel> feed) async {
    final jsonString = jsonEncode(feed.map((item) => item.toJson()).toList());
    await _box.put(CacheConstants.storyFeedKey, jsonString);
  }

  @override
  Future<List<StoryFeedItemModel>> getCachedStoryFeed() async {
    final jsonString = _box.get(CacheConstants.storyFeedKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => StoryFeedItemModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheGroupStories(int groupId, List<StoryModel> stories) async {
    final jsonString = jsonEncode(stories.map((s) => s.toJson()).toList());
    await _box.put('${CacheConstants.groupStoriesPrefix}$groupId', jsonString);
  }

  @override
  Future<List<StoryModel>> getCachedGroupStories(int groupId) async {
    final jsonString = _box.get('${CacheConstants.groupStoriesPrefix}$groupId');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => StoryModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> markStoryAsViewedLocally(int storyId) async {
    for (final key in _box.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(CacheConstants.groupStoriesPrefix)) {
        final jsonString = _box.get(keyStr);
        if (jsonString != null) {
          final List<dynamic> jsonList = jsonDecode(jsonString);
          final List<StoryModel> stories = jsonList
              .map((json) => StoryModel.fromJson(json))
              .toList();

          final index = stories.indexWhere((s) => s.id == storyId);
          if (index != -1) {
            final oldStory = stories[index];
            final updatedStory = StoryModel(
              id: oldStory.id,
              caption: oldStory.caption,
              mediaURL: oldStory.mediaURL,
              createdAt: oldStory.createdAt,
              expiresAt: oldStory.expiresAt,
              viewsCount: oldStory.viewsCount,
              creatorId: oldStory.creatorId,
              creatorUserName: oldStory.creatorUserName,
              groupProfilePicture: oldStory.groupProfilePicture,
              isViewedByCurrentUser: true,
            );
            stories[index] = updatedStory;

            // Save updated group stories
            await _box.put(
              keyStr,
              jsonEncode(stories.map((s) => s.toJson()).toList()),
            );

            // Find group ID from key
            final groupIdStr = keyStr.replaceFirst(
              CacheConstants.groupStoriesPrefix,
              '',
            );
            final groupId = int.tryParse(groupIdStr);

            // Check if all stories in this group are viewed
            final allViewed = stories.every((s) => s.isViewedByCurrentUser);
            if (allViewed && groupId != null) {
              // Update feed item state
              final feedJsonString = _box.get(CacheConstants.storyFeedKey);
              if (feedJsonString != null) {
                final List<dynamic> feedJsonList = jsonDecode(feedJsonString);
                final List<StoryFeedItemModel> feedItems = feedJsonList
                    .map((json) => StoryFeedItemModel.fromJson(json))
                    .toList();

                final feedIndex = feedItems.indexWhere(
                  (item) => item.groupId == groupId,
                );
                if (feedIndex != -1) {
                  final oldFeedItem = feedItems[feedIndex];
                  final updatedFeedItem = StoryFeedItemModel(
                    groupId: oldFeedItem.groupId,
                    groupName: oldFeedItem.groupName,
                    groupProfilePicture: oldFeedItem.groupProfilePicture,
                    hasUnseenStories: false,
                    latestStoryDate: oldFeedItem.latestStoryDate,
                  );
                  feedItems[feedIndex] = updatedFeedItem;
                  await _box.put(
                    CacheConstants.storyFeedKey,
                    jsonEncode(feedItems.map((item) => item.toJson()).toList()),
                  );
                }
              }
            }
            break; // Since story ID is unique, stop searching
          }
        }
      }
    }
  }

  @override
  Future<void> deleteStoryLocally(int storyId) async {
    for (final key in _box.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(CacheConstants.groupStoriesPrefix)) {
        final jsonString = _box.get(keyStr);
        if (jsonString != null) {
          final List<dynamic> jsonList = jsonDecode(jsonString);
          final List<StoryModel> stories = jsonList
              .map((json) => StoryModel.fromJson(json))
              .toList();

          final index = stories.indexWhere((s) => s.id == storyId);
          if (index != -1) {
            stories.removeAt(index);

            final groupIdStr = keyStr.replaceFirst(
              CacheConstants.groupStoriesPrefix,
              '',
            );
            final groupId = int.tryParse(groupIdStr);

            if (stories.isEmpty) {
              // No stories left in this group, delete this group stories box key
              await _box.delete(keyStr);

              // Also remove this group from the main feed cache
              if (groupId != null) {
                final feedJsonString = _box.get(CacheConstants.storyFeedKey);
                if (feedJsonString != null) {
                  final List<dynamic> feedJsonList = jsonDecode(feedJsonString);
                  final List<StoryFeedItemModel> feedItems = feedJsonList
                      .map((json) => StoryFeedItemModel.fromJson(json))
                      .toList();

                  feedItems.removeWhere((item) => item.groupId == groupId);
                  await _box.put(
                    CacheConstants.storyFeedKey,
                    jsonEncode(feedItems.map((item) => item.toJson()).toList()),
                  );
                }
              }
            } else {
              // Save the updated list of stories
              await _box.put(
                keyStr,
                jsonEncode(stories.map((s) => s.toJson()).toList()),
              );

              // Update the corresponding feed item's state and latest story date
              if (groupId != null) {
                final feedJsonString = _box.get(CacheConstants.storyFeedKey);
                if (feedJsonString != null) {
                  final List<dynamic> feedJsonList = jsonDecode(feedJsonString);
                  final List<StoryFeedItemModel> feedItems = feedJsonList
                      .map((json) => StoryFeedItemModel.fromJson(json))
                      .toList();

                  final feedIndex = feedItems.indexWhere(
                    (item) => item.groupId == groupId,
                  );
                  if (feedIndex != -1) {
                    final oldFeedItem = feedItems[feedIndex];
                    final hasUnseen = stories.any(
                      (s) => !s.isViewedByCurrentUser,
                    );
                    final latestDate = stories
                        .map((s) => s.createdAt)
                        .reduce((a, b) => a.compareTo(b) > 0 ? a : b);

                    final updatedFeedItem = StoryFeedItemModel(
                      groupId: oldFeedItem.groupId,
                      groupName: oldFeedItem.groupName,
                      groupProfilePicture: oldFeedItem.groupProfilePicture,
                      hasUnseenStories: hasUnseen,
                      latestStoryDate: latestDate,
                    );
                    feedItems[feedIndex] = updatedFeedItem;
                    await _box.put(
                      CacheConstants.storyFeedKey,
                      jsonEncode(
                        feedItems.map((item) => item.toJson()).toList(),
                      ),
                    );
                  }
                }
              }
            }
            break; // Stop searching once deleted
          }
        }
      }
    }
  }

  @override
  Future<void> clearCache() async {
    await _box.clear();
  }
}
