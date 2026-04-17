import 'package:equatable/equatable.dart';
import 'package:tribe_up/core/enums/comment_operations.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

class CommentsStates extends Equatable {
  final List<CommentItemEntity> comments;
  final CommentOperations? commentOperation;
  final CommentItemEntity? selectedComment;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int? currentPostId;
  final int currentPage;
  final int? editingCommentId;

  const CommentsStates({
    this.comments = const [],
    this.commentOperation,
    this.selectedComment,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPostId,
    this.currentPage = 1,
    this.editingCommentId,
  });

  CommentsStates copyWith({
    List<CommentItemEntity>? comments,
    CommentOperations? commentOperation,
    CommentItemEntity? selectedComment,
    bool clearOperation = false,
    bool clearSelectedComment = false,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPostId,
    int? currentPage,
    int? editingCommentId,
    bool clearEditing = false,
  }) {
    return CommentsStates(
      comments: comments ?? this.comments,
      commentOperation: clearOperation
          ? null
          : commentOperation ?? this.commentOperation,
      selectedComment: clearSelectedComment
          ? null
          : selectedComment ?? this.selectedComment,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPostId: currentPostId ?? this.currentPostId,
      currentPage: currentPage ?? this.currentPage,
      editingCommentId: clearEditing
          ? null
          : editingCommentId ?? this.editingCommentId,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    commentOperation,
    selectedComment,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPostId,
    currentPage,
    editingCommentId,
  ];
}
