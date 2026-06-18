import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/use_case/delete_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/edit_post_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/get_post_by_id_use_case.dart';
import 'package:tribe_up/features/feed/domain/use_case/toggle_like_post_use_case.dart';
import 'package:tribe_up/features/feed/presentation/cubit/post_detail_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/post_detail_ui_intents.dart';

@injectable
class PostDetailCubit extends Cubit<PostDetailStates> {
  final GetPostByIdUseCase _getPostByIdUseCase;
  final ToggleLikePostUseCase _toggleLikePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final EditPostUseCase _editPostUseCase;

  final StreamController<PostDetailUiIntents> _uiIntentController =
      StreamController<PostDetailUiIntents>.broadcast();

  Stream<PostDetailUiIntents> get uiIntents => _uiIntentController.stream;

  PostDetailCubit(
    this._getPostByIdUseCase,
    this._toggleLikePostUseCase,
    this._deletePostUseCase,
    this._editPostUseCase,
  ) : super(const PostDetailStates());

  Future<void> loadPostDetail(int postId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final response = await _getPostByIdUseCase(postId: postId);

    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(isLoading: false, data: data, clearError: true));
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
        _uiIntentController.add(PostDetailShowErrorIntent(error.message));
    }
  }

  Future<void> toggleLike(int postId) async {
    final post = state.data;
    if (post == null || state.isTogglingLike) return;

    // Optimistic UI update
    final wasLiked = post.isLikedByCurrentUser;
    final currentCount = post.likesCount ?? 0;
    final updatedPost = post.copyWith(
      isLikedByCurrentUser: !wasLiked,
      likesCount: wasLiked ? currentCount - 1 : currentCount + 1,
    );
    emit(state.copyWith(data: updatedPost, isTogglingLike: true));

    final response = await _toggleLikePostUseCase(postId: postId);

    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            data: state.data?.copyWith(
              isLikedByCurrentUser: data.isLiked,
              likesCount: data.likesCount,
            ),
            isTogglingLike: false,
          ),
        );
      case ErrorResponse(:final error):
        // Revert on error
        emit(state.copyWith(data: post, isTogglingLike: false));
        _uiIntentController.add(PostDetailShowErrorIntent(error.message));
    }
  }

  Future<void> deletePost(int postId) async {
    if (state.isDeleting) return;
    emit(state.copyWith(isDeleting: true));

    final response = await _deletePostUseCase(postId: postId);

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isDeleting: false));
        _uiIntentController.add(const PostDetailDeleteSuccessIntent());
      case ErrorResponse(:final error):
        emit(state.copyWith(isDeleting: false));
        _uiIntentController.add(PostDetailShowErrorIntent(error.message));
    }
  }

  Future<void> editPost({
    required int postId,
    required String caption,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  }) async {
    if (state.isEditing) return;
    emit(state.copyWith(isEditing: true));

    final response = await _editPostUseCase(
      postId: postId,
      caption: caption,
      newMediaFiles: newMediaFiles,
      deleteMediaIds: deleteMediaIds,
    );

    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(data: data, isEditing: false));
        _uiIntentController.add(const PostDetailEditSuccessIntent());
      case ErrorResponse(:final error):
        emit(state.copyWith(isEditing: false));
        _uiIntentController.add(PostDetailShowErrorIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
