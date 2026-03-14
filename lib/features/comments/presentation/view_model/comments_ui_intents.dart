import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

sealed class CommentsUiIntents {}

class ShowCommentBottomSheetIntent extends CommentsUiIntents {
  final List<CommentItemEntity> comments;
  ShowCommentBottomSheetIntent({required this.comments});
}

class ShowCommentLoadingIntent extends CommentsUiIntents {
  ShowCommentLoadingIntent();
}

class ShowCommentErrorIntent extends CommentsUiIntents {
  final String errorMessage;

  ShowCommentErrorIntent({required this.errorMessage});
}

class ShowCommentOptionsUiIntent extends CommentsUiIntents {
  final CommentItemEntity comment;
  ShowCommentOptionsUiIntent({required this.comment});
}
