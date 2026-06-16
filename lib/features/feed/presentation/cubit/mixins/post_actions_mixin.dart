import 'dart:io';

import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';

mixin PostActionsMixin {
  ToggleLikePostUseCase get toggleLikePostUseCase;
  DeletePostUseCase get deletePostUseCase;
  EditPostUseCase get editPostUseCase;
  List<PostEntity> get posts;
  Set<int> get togglingLikePostIds;
  Set<int> get deletingPostIds;
  Set<int> get editingPostIds;

  void applyPostsUpdate({
    List<PostEntity>? posts,
    Set<int>? togglingLikePostIds,
    Set<int>? deletingPostIds,
    Set<int>? editingPostIds,
  });

  void emitSuccess(String message);
  void emitError(String message);

  Future<void> performToggleLike(int postId) async {
    final originalPosts = List<PostEntity>.from(posts);

    final optimistic = posts.map((p) {
      if (p.postId != postId) return p;
      final liked = !p.isLikedByCurrentUser;
      return _copyPost(
        p,
        isLiked: liked,
        likesCount: liked ? (p.likesCount ?? 0) + 1 : (p.likesCount ?? 0) - 1,
      );
    }).toList();

    applyPostsUpdate(
      posts: optimistic,
      togglingLikePostIds: {...togglingLikePostIds, postId},
    );

    final response = await toggleLikePostUseCase(postId: postId);
    final doneIds = {...togglingLikePostIds}..remove(postId);

    switch (response) {
      case SuccessResponse():
        applyPostsUpdate(togglingLikePostIds: doneIds);
      case ErrorResponse():
        applyPostsUpdate(posts: originalPosts, togglingLikePostIds: doneIds);
    }
  }

  Future<void> performDeletePost(int postId) async {
    applyPostsUpdate(deletingPostIds: {...deletingPostIds, postId});

    final response = await deletePostUseCase(postId: postId);
    final doneIds = {...deletingPostIds}..remove(postId);

    switch (response) {
      case SuccessResponse():
        final updated = posts.where((p) => p.postId != postId).toList();
        applyPostsUpdate(posts: updated, deletingPostIds: doneIds);
        emitSuccess(UiConstants.postDeleted);
      case ErrorResponse(:final error):
        applyPostsUpdate(deletingPostIds: doneIds);
        emitError(error.message);
    }
  }

  Future<void> performEditPost({
    required int postId,
    required String caption,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  }) async {
    final editingIds = {...editingPostIds, postId};
    applyPostsUpdate(editingPostIds: editingIds);

    final originalPosts = List<PostEntity>.from(posts);

    final postIndex = posts.indexWhere((p) => p.postId == postId);
    final int? groupId = postIndex != -1 ? posts[postIndex].groupId : null;

    final optimistic = posts.map((p) {
      if (p.postId != postId) return p;
      return _copyPost(p, caption: caption);
    }).toList();
    applyPostsUpdate(posts: optimistic);

    final response = await editPostUseCase(
      postId: postId,
      caption: caption,
      groupId: groupId,
      newMediaFiles: newMediaFiles,
      deleteMediaIds: deleteMediaIds,
    );

    final doneIds = {...editingPostIds}..remove(postId);

    switch (response) {
      case SuccessResponse(:final data):
        final updated = posts.map((p) {
          if (p.postId == postId) {
            return _copyPost(
              data,
              isAuthor: p.isAuthor,
              canDelete: p.canDelete,
              isLiked: p.isLikedByCurrentUser,
              likesCount: p.likesCount,
              commentCount: p.commentCount,
            );
          }
          return p;
        }).toList();
        applyPostsUpdate(posts: updated, editingPostIds: doneIds);
        emitSuccess(UiConstants.postUpdated);
      case ErrorResponse(:final error):
        applyPostsUpdate(posts: originalPosts, editingPostIds: doneIds);
        emitError(error.message);
    }
  }

  PostEntity _copyPost(
    PostEntity p, {
    String? caption,
    bool? isLiked,
    int? likesCount,
    int? commentCount,
    bool? isAuthor,
    bool? canDelete,
  }) {
    return PostEntity(
      postId: p.postId,
      caption: caption ?? p.caption,
      userId: p.userId,
      username: p.username,
      groupId: p.groupId,
      groupName: p.groupName,
      groupProfilePicture: p.groupProfilePicture,
      likesCount: likesCount ?? p.likesCount,
      commentCount: commentCount ?? p.commentCount,
      isLikedByCurrentUser: isLiked ?? p.isLikedByCurrentUser,
      feedScore: p.feedScore,
      createdAt: p.createdAt,
      media: p.media,
      isDenied: p.isDenied,
      isAuthor: isAuthor ?? p.isAuthor,
      canDelete: canDelete ?? p.canDelete,
    );
  }
}
