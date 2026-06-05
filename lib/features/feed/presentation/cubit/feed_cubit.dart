import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/mixins/post_actions_mixin.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/feed_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_ui_intents.dart';
import 'package:tribe_up/features/groups/domain/use_cases/my_groups_use_case.dart';

@injectable
class FeedCubit extends Cubit<FeedStates> with PostActionsMixin {
  final FeedUseCase _feedUseCase;
  final MyGroupsUseCase _myGroupsUseCase;

  @override
  final DeletePostUseCase deletePostUseCase;
  @override
  final EditPostUseCase editPostUseCase;
  @override
  final ToggleLikePostUseCase toggleLikePostUseCase;

  final StreamController<FeedUiIntents> _uiIntentController =
      StreamController.broadcast();

  Stream<FeedUiIntents> get uiIntents => _uiIntentController.stream;

  FeedCubit(
    this._feedUseCase,
    this.deletePostUseCase,
    this.editPostUseCase,
    this.toggleLikePostUseCase,
    this._myGroupsUseCase,
  ) : super(const FeedStates());

  // ── Mixin state accessors ────────────────────────────────────────────────────

  @override
  List<PostEntity> get posts => state.posts;

  @override
  Set<int> get togglingLikePostIds => state.togglingLikePostIds;

  @override
  Set<int> get deletingPostIds => state.deletingPostIds;

  @override
  Set<int> get editingPostIds => state.editingPostIds;

  @override
  void applyPostsUpdate({
    List<PostEntity>? posts,
    Set<int>? togglingLikePostIds,
    Set<int>? deletingPostIds,
    Set<int>? editingPostIds,
  }) {
    emit(
      state.copyWith(
        posts: posts,
        togglingLikePostIds: togglingLikePostIds,
        deletingPostIds: deletingPostIds,
        editingPostIds: editingPostIds,
      ),
    );
  }

  @override
  void emitSuccess(String message) =>
      _uiIntentController.add(ShowSuccessUiIntent(message));

  @override
  void emitError(String message) =>
      _uiIntentController.add(ShowErrorUiIntent(message));

  // ── Intent handler ───────────────────────────────────────────────────────────

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
        performDeletePost(postId);
      case ToggleLikeIntent(:final postId):
        performToggleLike(postId);
      case PostCreatedIntent(:final post):
        _onPostCreated(post);
      case EditPostIntent(
        :final postId,
        :final caption,
        :final newMediaFiles,
        :final deleteMediaIds,
      ):
        performEditPost(
          postId: postId,
          caption: caption,
          newMediaFiles: newMediaFiles,
          deleteMediaIds: deleteMediaIds,
        );
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

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

  void _onPostCreated(PostEntity post) {
    emit(state.copyWith(posts: [post, ...state.posts]));
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
