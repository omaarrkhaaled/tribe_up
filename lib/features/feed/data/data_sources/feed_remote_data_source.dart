import 'dart:io';

import 'package:tribe_up/features/feed/data/models/create_post_response.dart';
import 'package:tribe_up/features/feed/data/models/feed_response.dart';
import 'package:tribe_up/features/feed/data/models/toggle_like_response.dart';

abstract class FeedRemoteDataSource {
  Future<FeedResponse> getFeedPosts({int page, int pageSize});

  Future<FeedResponse> getGroupFeedPosts({
    required int groupId,
    int page,
    int pageSize,
  });

  Future<CreatePostResponse> createPost({
    int? groupId,
    required String caption,
    required int accessibility,
    List<String>? taggedUserIds,
    List<File>? mediaFiles,
  });

  Future<void> deletePost({required int postId});

  Future<ToggleLikeResponse> toggleLikePost({required int postId});

  Future<CreatePostResponse> editPost({
    required int postId,
    required String caption,
    int? groupId,
    int? accessibility,
    List<String>? taggedUserIds,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  });
}
