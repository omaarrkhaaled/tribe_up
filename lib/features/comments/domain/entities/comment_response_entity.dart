import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';

class CommentsResponseEntity {
  final List<CommentItemEntity>? items;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final bool? hasMore;

  const CommentsResponseEntity({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });
}
