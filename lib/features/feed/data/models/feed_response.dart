import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/feed/data/models/post_model.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';

part 'feed_response.g.dart';

@JsonSerializable()
class FeedResponse {
  @JsonKey(name: 'items')
  final List<PostModel> items;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'pageSize')
  final int pageSize;
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @JsonKey(name: 'hasMore')
  final bool hasMore;

  const FeedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);

  FeedResponseEntity toEntity() {
    return FeedResponseEntity(
      posts: items.map((e) => e.toEntity()).toList(),
      currentPage: page,
      totalPages: (totalCount / pageSize).ceil(),
      totalItems: totalCount,
    );
  }
}
