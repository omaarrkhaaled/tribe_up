import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/feed_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_ui_intents.dart';
import 'package:tribe_up/features/groups/domain/use_cases/my_groups_use_case.dart';

@injectable
class FeedCubit extends Cubit<FeedStates> {
  final FeedUseCase _feedUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final EditPostUseCase _editPostUseCase;
  final ToggleLikePostUseCase _toggleLikePostUseCase;
  final MyGroupsUseCase _myGroupsUseCase;

  final StreamController<FeedUiIntents> _uiIntentController =
      StreamController.broadcast();

  Stream<FeedUiIntents> get uiIntents => _uiIntentController.stream;

  FeedCubit(
    this._feedUseCase,
    this._deletePostUseCase,
    this._editPostUseCase,
    this._toggleLikePostUseCase,
    this._myGroupsUseCase,
  ) : super(const FeedStates());

  void doIntent(FeedIntents intent) {
    switch (intent) {
      case SelectTabIntent(:final tab):
        _selectTab(tab);
      case LoadFeedIntent():
        _loadFeed();
        _loadJoinedGroups();
      case RefreshFeedIntent():
        _loadFeed();
      case LoadJoinedGroupsIntent():
        _loadJoinedGroups();
      case DeletePostIntent(:final postId):
        _deletePost(postId);
      case ToggleLikeIntent(:final postId):
        _toggleLike(postId);
      case PostCreatedIntent(:final post):
        _onPostCreated(post);
      case EditPostIntent(
        :final postId,
        :final caption,
        :final newMediaFiles,
        :final deleteMediaIds,
      ):
        _editPost(
          postId: postId,
          caption: caption,
          newMediaFiles: newMediaFiles,
          deleteMediaIds: deleteMediaIds,
        );
    }
  }

  void _selectTab(FeedNavTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  Future<void> _loadFeed() async {
    emit(state.copyWith(isLoading: true));
    final response = await _feedUseCase(page: 1, pageSize: 20);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(posts: data.posts, isLoading: false, clearError: true),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, error: error.message));
    }
  }

  Future<void> _loadJoinedGroups() async {
    emit(state.copyWith(isLoadingGroups: true));
    final response = await _myGroupsUseCase(1, 50);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            joinedGroups: data.items ?? [],
            isLoadingGroups: false,
          ),
        );
      case ErrorResponse():
        emit(state.copyWith(isLoadingGroups: false));
    }
  }

  Future<void> _deletePost(int postId) async {
    final pendingIds = {...state.deletingPostIds, postId};
    emit(state.copyWith(deletingPostIds: pendingIds));

    final response = await _deletePostUseCase(postId: postId);

    final updatedIds = {...state.deletingPostIds}..remove(postId);

    switch (response) {
      case SuccessResponse():
        final updatedPosts = state.posts
            .where((p) => p.postId != postId)
            .toList();
        emit(state.copyWith(posts: updatedPosts, deletingPostIds: updatedIds));
        _uiIntentController.add(const ShowSuccessUiIntent('Post deleted'));
      case ErrorResponse(:final error):
        emit(state.copyWith(deletingPostIds: updatedIds));
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _toggleLike(int postId) async {
    // Optimistic update
    final updatedPosts = state.posts.map((p) {
      if (p.postId != postId) return p;
      final newLiked = !p.isLikedByCurrentUser;
      return PostEntity(
        postId: p.postId,
        caption: p.caption,
        userId: p.userId,
        username: p.username,
        groupId: p.groupId,
        groupName: p.groupName,
        groupProfilePicture: p.groupProfilePicture,
        likesCount: newLiked ? p.likesCount + 1 : p.likesCount - 1,
        commentCount: p.commentCount,
        isLikedByCurrentUser: newLiked,
        feedScore: p.feedScore,
        createdAt: p.createdAt,
        media: p.media,
        isDenied: p.isDenied,
        isAuthor: p.isAuthor,
        canDelete: p.canDelete,
      );
    }).toList();

    final togglingIds = {...state.togglingLikePostIds, postId};
    emit(state.copyWith(posts: updatedPosts, togglingLikePostIds: togglingIds));

    final response = await _toggleLikePostUseCase(postId: postId);
    final doneIds = {...state.togglingLikePostIds}..remove(postId);

    switch (response) {
      case SuccessResponse(:final data):
        // Sync with server truth
        final synced = state.posts.map((p) {
          if (p.postId != postId) return p;
          return PostEntity(
            postId: p.postId,
            caption: p.caption,
            userId: p.userId,
            username: p.username,
            groupId: p.groupId,
            groupName: p.groupName,
            groupProfilePicture: p.groupProfilePicture,
            likesCount: data.likesCount,
            commentCount: p.commentCount,
            isLikedByCurrentUser: data.isLiked,
            feedScore: p.feedScore,
            createdAt: p.createdAt,
            media: p.media,
            isDenied: p.isDenied,
            isAuthor: p.isAuthor,
            canDelete: p.canDelete,
          );
        }).toList();
        emit(state.copyWith(posts: synced, togglingLikePostIds: doneIds));
      case ErrorResponse():
        // Rollback optimistic update
        emit(state.copyWith(posts: state.posts, togglingLikePostIds: doneIds));
    }
  }

  void _onPostCreated(PostEntity post) {
    final updatedPosts = [post, ...state.posts];
    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _editPost({
    required int postId,
    required String caption,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  }) async {
    final editingIds = {...state.editingPostIds, postId};
    emit(state.copyWith(editingPostIds: editingIds));

    final response = await _editPostUseCase(
      postId: postId,
      caption: caption,
      newMediaFiles: newMediaFiles,
      deleteMediaIds: deleteMediaIds,
    );

    final doneIds = {...state.editingPostIds}..remove(postId);

    switch (response) {
      case SuccessResponse():
        // Update caption in local state immediately
        final updatedPosts = state.posts.map((p) {
          if (p.postId != postId) return p;
          return PostEntity(
            postId: p.postId,
            caption: caption,
            userId: p.userId,
            username: p.username,
            groupId: p.groupId,
            groupName: p.groupName,
            groupProfilePicture: p.groupProfilePicture,
            likesCount: p.likesCount,
            commentCount: p.commentCount,
            isLikedByCurrentUser: p.isLikedByCurrentUser,
            feedScore: p.feedScore,
            createdAt: p.createdAt,
            media: p.media,
            isDenied: p.isDenied,
            isAuthor: p.isAuthor,
            canDelete: p.canDelete,
          );
        }).toList();
        emit(state.copyWith(posts: updatedPosts, editingPostIds: doneIds));
        _uiIntentController.add(const ShowSuccessUiIntent('Post updated'));
      case ErrorResponse(:final error):
        emit(state.copyWith(editingPostIds: doneIds));
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
