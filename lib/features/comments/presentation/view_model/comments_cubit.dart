import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/comment_operations.dart';
import 'package:tribe_up/features/comments/domain/use_cases/add_comment_use_case.dart';
import 'package:tribe_up/features/comments/domain/use_cases/delete_comment_use_case.dart';
import 'package:tribe_up/features/comments/domain/use_cases/edit_comment_use_case.dart';
import 'package:tribe_up/features/comments/domain/use_cases/get_comments_use_case.dart';
import 'package:tribe_up/features/comments/domain/use_cases/like_comment_use_case.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_states.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_ui_intents.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

@lazySingleton
class CommentsCubit extends Cubit<CommentsStates> {
  final StreamController<CommentsUiIntents> _commentsStreamController =
      StreamController<CommentsUiIntents>.broadcast();

  Stream<CommentsUiIntents> get commentsStream =>
      _commentsStreamController.stream;

  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final EditCommentUseCase editCommentUseCase;
  final LikeCommentUseCase likeCommentUseCase;

  static const int _pageSize = 20;
  bool _isFetching = false;

  CommentsCubit({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.deleteCommentUseCase,
    required this.editCommentUseCase,
    required this.likeCommentUseCase,
  }) : super(const CommentsStates());

  void doIntent(CommentsIntents intent) {
    switch (intent) {
      case GetCommentsIntent(:final postId):
        _getComments(postId: postId);

      case AddCommentIntent(
        :final postId,
        :final content,
        :final taggedUserIds,
      ):
        _addComment(
          postId: postId,
          content: content,
          taggedUserIds: taggedUserIds,
        );

      case DeleteCommentIntent(:final commentId):
        _deleteComment(commentId: commentId);

      case EditCommentIntent(
        :final commentId,
        :final content,
        :final taggedUserIds,
      ):
        _editComment(
          commentId: commentId,
          content: content,
          taggedUserIds: taggedUserIds,
        );
      case LikeCommentIntent(:final commentId):
        _toggleLike(commentId: commentId);
      case ShowCommentOptionsIntent(:final comment):
        _commentsStreamController.add(
          ShowCommentOptionsUiIntent(comment: comment),
        );
      case LoadMoreCommentsIntent(:final postId):
        _loadMoreComments(postId: postId);
      case StartEditCommentIntent(:final commentId):
        _startEditComment(commentId);
      case CancelEditCommentIntent():
        _cancelEditComment();
    }
  }

  // ---------------------------------------------------------------------------
  // Get Comments
  // ---------------------------------------------------------------------------

  Future<void> _getComments({required int postId}) async {
    emit(state.copyWith(isLoading: true));

    final response = await getCommentsUseCase(
      postId: postId,
      page: 1,
      pageSize: _pageSize,
    );

    switch (response) {
      case SuccessResponse(:final data):
        final comments = data.items ?? [];
        final sortedComments = [
          ...comments.where((c) => c.isAuthor == true),
          ...comments.where((c) => c.isAuthor != true),
        ];
        emit(
          state.copyWith(
            isLoading: false,
            comments: sortedComments,
            hasMore: (data.items?.length ?? 0) >= _pageSize,
            currentPage: 1,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
  }

  Future<void> _loadMoreComments({required int postId}) async {
    if (!state.hasMore || _isFetching) return;
    _isFetching = true;

    emit(state.copyWith(isLoading: true));

    final nextPage = state.currentPage + 1;

    final response = await getCommentsUseCase(
      postId: postId,
      page: nextPage,
      pageSize: _pageSize,
    );

    switch (response) {
      case SuccessResponse(:final data):
        final newItems = data.items ?? [];
        emit(
          state.copyWith(
            isLoading: false,
            comments: [...state.comments, ...newItems],
            currentPage: nextPage,
            hasMore: newItems.length >= _pageSize,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
    _isFetching = false;
  }

  // ---------------------------------------------------------------------------
  // Add Comment
  // ---------------------------------------------------------------------------

  Future<void> _addComment({
    required int postId,
    required String content,
    List<String>? taggedUserIds,
  }) async {
    if (content.trim().isEmpty) return;

    emit(state.copyWith(commentOperation: CommentOperations.add));

    final response = await addCommentUseCase(
      postId: postId,
      content: content.trim(),
      taggedUserIds: taggedUserIds,
    );

    switch (response) {
      case SuccessResponse(:final data):
        final newComment = data.comment;
        emit(
          state.copyWith(
            clearOperation: true,
            comments: [if (newComment != null) newComment, ...state.comments],
          ),
        );

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Delete Comment
  // ---------------------------------------------------------------------------

  Future<void> _deleteComment({required int commentId}) async {
    emit(state.copyWith(commentOperation: CommentOperations.delete));

    final response = await deleteCommentUseCase(commentId: commentId);

    switch (response) {
      case SuccessResponse():
        final updatedList = state.comments
            .where((c) => c.id != commentId)
            .toList();
        emit(
          state.copyWith(
            clearOperation: true,
            clearEditing: true,
            comments: updatedList,
          ),
        );

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Edit Comment
  // ---------------------------------------------------------------------------

  Future<void> _editComment({
    required int commentId,
    required String content,
    List<String>? taggedUserIds,
  }) async {
    if (content.trim().isEmpty) return;

    emit(state.copyWith(commentOperation: CommentOperations.edit));

    final response = await editCommentUseCase(
      commentId: commentId,
      content: content.trim(),
      taggedUserIds: taggedUserIds ?? [],
    );

    switch (response) {
      case SuccessResponse(:final data):
        final editedComment = data.comment;
        final updatedList = state.comments.map((comment) {
          if (comment.id == commentId && editedComment != null) {
            return comment.copyWith(content: editedComment.content);
          }
          return comment;
        }).toList();
        emit(
          state.copyWith(
            clearEditing: true,
            clearOperation: true,
            comments: updatedList,
          ),
        );

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
  }

  void _startEditComment(int commentId) {
    emit(state.copyWith(editingCommentId: commentId));
  }

  void _cancelEditComment() {
    emit(state.copyWith(clearEditing: true));
  }

  // ---------------------------------------------------------------------------
  // Toggle Like
  // ---------------------------------------------------------------------------
  DateTime? _lastLikeTap;

  Future<void> _toggleLike({required int commentId}) async {
    final now = DateTime.now();
    if (_lastLikeTap != null &&
        now.difference(_lastLikeTap!) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastLikeTap = now;

    final originalList = state.comments;
    final optimisticList = state.comments.map((comment) {
      if (comment.id == commentId) {
        final wasLiked = comment.isLikedByCurrentUser ?? false;
        return comment.copyWith(
          likesCount: (comment.likesCount ?? 0) + (wasLiked ? -1 : 1),
          isLikedByCurrentUser: !wasLiked,
        );
      }
      return comment;
    }).toList();

    emit(
      state.copyWith(comments: List<CommentItemEntity>.from(optimisticList)),
    );

    final response = await likeCommentUseCase(commentId);

    switch (response) {
      case SuccessResponse():
        break;
      case ErrorResponse(:final error):
        emit(state.copyWith(comments: originalList));
        _commentsStreamController.add(
          ShowCommentErrorIntent(errorMessage: error.message),
        );
    }
  }

  @override
  Future<void> close() {
    _commentsStreamController.close();
    return super.close();
  }
}
