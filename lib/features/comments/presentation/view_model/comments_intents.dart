import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

sealed class CommentsIntents {
  const CommentsIntents();
}

class ShowCommentOptionsIntent extends CommentsIntents {
  final CommentItemEntity comment;
  const ShowCommentOptionsIntent({required this.comment});
}

class GetCommentsIntent extends CommentsIntents {
  final int postId;
  const GetCommentsIntent({required this.postId});
}

class AddCommentIntent extends CommentsIntents {
  final int postId;
  final String content;
  final List<String>? taggedUserIds;

  const AddCommentIntent({
    required this.postId,
    required this.content,
    this.taggedUserIds,
  });
}

class DeleteCommentIntent extends CommentsIntents {
  final int commentId;

  const DeleteCommentIntent({required this.commentId});
}

class EditCommentIntent extends CommentsIntents {
  final int commentId;
  final String content;
  final List<String>? taggedUserIds;

  const EditCommentIntent({
    required this.commentId,
    required this.content,
    this.taggedUserIds,
  });
}

class LikeCommentIntent extends CommentsIntents {
  final int commentId;

  const LikeCommentIntent({required this.commentId});
}

class LoadMoreCommentsIntent extends CommentsIntents {
  final int postId;
  const LoadMoreCommentsIntent({required this.postId});
}

class StartEditCommentIntent extends CommentsIntents {
  final int commentId;
  const StartEditCommentIntent({required this.commentId});
}

class CancelEditCommentIntent extends CommentsIntents {
  const CancelEditCommentIntent();
}
