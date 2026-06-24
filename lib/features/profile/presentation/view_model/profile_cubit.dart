import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/cubit/mixins/post_actions_mixin.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:tribe_up/features/profile/domain/usecases/get_personal_posts_use_case.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_states.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_ui_intents.dart';
import 'dart:async';

@injectable
class ProfileCubit extends Cubit<ProfileStates> with PostActionsMixin {
  final GetProfileUseCase _getProfileUseCase;
  final GetPersonalPostsUseCase _getPersonalPostsUseCase;

  @override
  final ToggleLikePostUseCase toggleLikePostUseCase;
  @override
  final DeletePostUseCase deletePostUseCase;
  @override
  final EditPostUseCase editPostUseCase;

  final StreamController<ProfileUiIntents> _uiIntentsController =
      StreamController<ProfileUiIntents>.broadcast();

  Stream<ProfileUiIntents> get uiIntents => _uiIntentsController.stream;

  ProfileCubit(
    this._getProfileUseCase,
    this._getPersonalPostsUseCase,
    this.toggleLikePostUseCase,
    this.deletePostUseCase,
    this.editPostUseCase,
  ) : super(const ProfileStates());

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
      _uiIntentsController.add(ShowSuccessProfileIntent(message: message));

  @override
  void emitError(String message) =>
      _uiIntentsController.add(ShowErrorProfileIntent(message: message));

  // ── Intent handler ───────────────────────────────────────────────────────────

  void doIntent(ProfileIntents intent) {
    switch (intent) {
      case GetProfileDetailsIntent():
        _getProfileDetails(intent.userName);
      case GetPersonalPostsIntent():
        _getPersonalPosts(intent.userName);
      case ToggleLikeIntent(:final postId):
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
          newMediaFiles: newMediaFiles,
          deleteMediaIds: deleteMediaIds,
        );
    }
  }

  Future<void> _getProfileDetails(String userName) async {
    emit(state.copyWith(isLoadingProfile: true));
    final response = await _getProfileUseCase(userName);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isLoadingProfile: false, profile: response.data));
      case ErrorResponse():
        emit(state.copyWith(isLoadingProfile: false));
        _uiIntentsController.add(
          ShowErrorProfileIntent(message: response.error.message),
        );
    }
  }

  Future<void> _getPersonalPosts(String userName) async {
    emit(state.copyWith(isLoadingPosts: true));
    final response = await _getPersonalPostsUseCase(userName: userName);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isLoadingPosts: false, posts: response.data.posts));
      case ErrorResponse():
        emit(state.copyWith(isLoadingPosts: false));
        _uiIntentsController.add(
          ShowErrorProfileIntent(message: response.error.message),
        );
    }
  }

  @override
  Future<void> close() {
    _uiIntentsController.close();
    return super.close();
  }
}
