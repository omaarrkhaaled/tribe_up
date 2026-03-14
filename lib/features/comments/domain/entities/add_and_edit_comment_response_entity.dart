import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

class AddAndEditCommentResponseEntity {
  final bool? isCreated;
  final int? status;
  final String? message;
  final CommentItemEntity? comment;

  const AddAndEditCommentResponseEntity({
    this.isCreated,
    this.status,
    this.message,
    this.comment,
  });
}
