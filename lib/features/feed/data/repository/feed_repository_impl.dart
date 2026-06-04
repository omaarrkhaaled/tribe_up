import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@Injectable(as: FeedRepository)
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;

  const FeedRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<FeedResponseEntity>> getFeedPosts({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall<FeedResponseEntity>(() async {
      final response = await _remoteDataSource.getFeedPosts(
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<FeedResponseEntity>> getGroupFeedPosts({
    required int groupId,
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall<FeedResponseEntity>(() async {
      final response = await _remoteDataSource.getGroupFeedPosts(
        groupId: groupId,
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<PostEntity>> createPost({
    int? groupId,
    required String caption,
    required int accessibility,
    List<String>? taggedUserIds,
    List<File>? mediaFiles,
  }) {
    return safeApiCall<PostEntity>(() async {
      final response = await _remoteDataSource.createPost(
        groupId: groupId,
        caption: caption,
        accessibility: accessibility,
        taggedUserIds: taggedUserIds,
        mediaFiles: mediaFiles,
      );
      return response.post.toEntity();
    });
  }

  @override
  Future<BaseResponse<bool>> deletePost({required int postId}) {
    return safeApiCall<bool>(() async {
      await _remoteDataSource.deletePost(postId: postId);
      return true;
    });
  }

  @override
  Future<BaseResponse<({bool isLiked, int likesCount})>> toggleLikePost({
    required int postId,
  }) {
    return safeApiCall<({bool isLiked, int likesCount})>(() async {
      final response = await _remoteDataSource.toggleLikePost(postId: postId);
      return (
        isLiked: response.isLiked ?? false,
        likesCount: response.likesCount ?? 0,
      );
    });
  }

  @override
  Future<BaseResponse<void>> editPost({
    required int postId,
    required String caption,
    int? groupId,
    int? accessibility,
    List<String>? taggedUserIds,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  }) {
    return safeApiCall<void>(() async {
      await _remoteDataSource.editPost(
        postId: postId,
        caption: caption,
        groupId: groupId,
        accessibility: accessibility,
        taggedUserIds: taggedUserIds,
        newMediaFiles: newMediaFiles,
        deleteMediaIds: deleteMediaIds,
      );
    });
  }
}
