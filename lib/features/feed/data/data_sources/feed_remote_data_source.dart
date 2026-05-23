import 'dart:io';

import 'package:tribe_up/features/feed/data/models/create_post_response.dart';
import 'package:tribe_up/features/feed/data/models/feed_response.dart';

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
}
