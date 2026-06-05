import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/mixins/post_actions_mixin.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/get_group_feed_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/get_group_by_id_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/leave_group_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/toggle_follow_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_ui_intents.dart';

@injectable
class TribeProfileCubit extends Cubit<TribeProfileState> with PostActionsMixin {
  final GetGroupByIdUseCase _getGroupByIdUseCase;
  final LeaveGroupUseCase _leaveGroupUseCase;
  final ToggleFollowUseCase _toggleFollowUseCase;
  final GetGroupFeedUseCase _getGroupFeedUseCase;

  @override
  final ToggleLikePostUseCase toggleLikePostUseCase;
  @override
  final DeletePostUseCase deletePostUseCase;
  @override
  final EditPostUseCase editPostUseCase;

  final StreamController<TribeProfileUiIntents> _uiController =
      StreamController.broadcast();
  Stream<TribeProfileUiIntents> get uiIntents => _uiController.stream;

  TribeProfileCubit(
    this._getGroupByIdUseCase,
    this._leaveGroupUseCase,
    this._toggleFollowUseCase,
    this._getGroupFeedUseCase,
    this.toggleLikePostUseCase,
    this.deletePostUseCase,
    this.editPostUseCase,
  ) : super(const TribeProfileState());

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
      _uiController.add(ShowSuccessUiIntent(message));

  @override
  void emitError(String message) =>
      _uiController.add(ShowErrorUiIntent(message));

  // ── Intent handler ───────────────────────────────────────────────────────────

  void doIntent(TribeProfileIntents intent) {
    switch (intent) {
      case LoadTribeIntent(:final groupId, :final initialGroup):
        _loadTribe(groupId, initialGroup: initialGroup);
      case RefreshTribeIntent(:final groupId):
        _loadTribe(groupId);
      case LeaveGroupIntent():
        _leaveGroup();
      case ToggleFollowIntent():
        _toggleFollow();
      case OpenTribeSettingsIntent(:final tribe):
        _uiController.add(OpenSettingsSheetUiIntent(tribe));
      case OpenInviteIntent():
        _uiController.add(OpenInviteSheetUiIntent(state.tribe?.id ?? 0));
      case LoadTribePostsIntent(:final groupId, :final refresh):
        _loadTribePosts(groupId, refresh: refresh);
      case AddCreatedPostIntent(:final post):
        emit(state.copyWith(posts: [post, ...state.posts]));
      case LoadMoreTribePostsIntent(:final groupId):
        _loadMoreTribePosts(groupId);
      case ToggleLikePostIntent(:final postId):
        performToggleLike(postId);
      case DeletePostIntent(:final postId):
        performDeletePost(postId);
      case EditPostIntent(
        :final postId,
        :final caption,
        :final newMediaFiles,
        :final deleteMediaIds,
      ):
        performEditPost(
          postId: postId,
          caption: caption,
          newMediaFiles: newMediaFiles?.cast<File>(),
          deleteMediaIds: deleteMediaIds,
        );
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  Future<void> _loadTribe(int groupId, {Group? initialGroup}) async {
    emit(
      state.copyWith(
        tribe: initialGroup ?? state.tribe,
        isLoading: state.tribe == null && initialGroup == null,
        isLoadingPosts: true,
        clearError: true,
      ),
    );
    final response = await _getGroupByIdUseCase(groupId);
    switch (response) {
      case SuccessResponse(:final data):
        var updatedData = data;
        final initialRelation =
            initialGroup?.userRelation ?? state.tribe?.userRelation;
        if ((data.userRelation == null || data.userRelation == 0) &&
            initialRelation != null &&
            initialRelation != 0) {
          updatedData = Group(
            id: data.id,
            groupName: data.groupName,
            description: data.description,
            groupProfilePicture: data.groupProfilePicture,
            createdAt: data.createdAt,
            accessibility: data.accessibility,
            userRelation: initialRelation,
            membersCount: data.membersCount,
          );
        }
        emit(state.copyWith(tribe: updatedData, isLoading: false));
        doIntent(LoadTribePostsIntent(groupId));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingPosts: false,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _leaveGroup() async {
    if (state.tribe == null) return;
    emit(state.copyWith(isActionLoading: true));
    final response = await _leaveGroupUseCase(state.tribe!.id!);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isActionLoading: false));
        _uiController.add(const NavigateBackUiIntent(didChangeTribe: true));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isActionLoading: false, errorMessage: error.message),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _toggleFollow() async {
    if (state.tribe == null) return;
    emit(state.copyWith(isActionLoading: true));
    final response = await _toggleFollowUseCase(state.tribe!.id!);
    switch (response) {
      case SuccessResponse(:final data):
        final current = state.tribe!;
        final updatedTribe = Group(
          id: current.id,
          groupName: current.groupName,
          description: current.description,
          groupProfilePicture: current.groupProfilePicture,
          createdAt: current.createdAt,
          accessibility: current.accessibility,
          userRelation: data.currentRelation,
          membersCount: current.membersCount,
        );
        emit(state.copyWith(tribe: updatedTribe, isActionLoading: false));
        final relation = UserRelation.fromInt(data.currentRelation);
        final msg = relation == UserRelation.follower
            ? UiConstants.followingTribe
            : UiConstants.unfollowedTribe;
        _uiController.add(ShowSuccessUiIntent(msg));
        doIntent(LoadTribePostsIntent(current.id!));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isActionLoading: false, errorMessage: error.message),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadTribePosts(int groupId, {bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoadingPosts: true,
        clearPostsError: true,
        posts: [],
        postsPage: 1,
        hasMorePosts: true,
      ),
    );
    final response = await _getGroupFeedUseCase(
      groupId: groupId,
      page: 1,
      pageSize: 10,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            isLoadingPosts: false,
            posts: data.posts,
            hasMorePosts: data.posts.length < data.totalItems,
            postsPage: 1,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingPosts: false,
            postsErrorMessage: error.message,
          ),
        );
    }
  }

  Future<void> _loadMoreTribePosts(int groupId) async {
    if (state.isLoadingPosts || !state.hasMorePosts) return;
    emit(state.copyWith(isLoadingPosts: true, clearPostsError: true));
    final nextPage = state.postsPage + 1;
    final response = await _getGroupFeedUseCase(
      groupId: groupId,
      page: nextPage,
      pageSize: 10,
    );
    switch (response) {
      case SuccessResponse(:final data):
        final List<PostEntity> updatedList = List.from(state.posts)
          ..addAll(data.posts);
        emit(
          state.copyWith(
            isLoadingPosts: false,
            posts: updatedList,
            hasMorePosts: updatedList.length < data.totalItems,
            postsPage: nextPage,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingPosts: false,
            postsErrorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
