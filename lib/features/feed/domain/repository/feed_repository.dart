import 'dart:io';

import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

abstract class FeedRepository {
  Future<BaseResponse<FeedResponseEntity>> getFeedPosts({
    int page,
    int pageSize,
  });

  Future<BaseResponse<FeedResponseEntity>> getGroupFeedPosts({
    required int groupId,
    int page,
    int pageSize,
  });

  Future<BaseResponse<PostEntity>> createPost({
    int? groupId,
    required String caption,
    required int accessibility,
    List<String>? taggedUserIds,
    List<File>? mediaFiles,
  });
}
