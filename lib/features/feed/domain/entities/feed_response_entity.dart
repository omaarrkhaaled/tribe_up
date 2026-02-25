import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class FeedResponseEntity {
  final List<PostEntity> posts;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const FeedResponseEntity({
    required this.posts,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}
