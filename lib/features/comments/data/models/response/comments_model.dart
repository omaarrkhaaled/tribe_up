import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/comments/data/models/response/comment_item_model.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_response_entity.dart';

part 'comments_model.g.dart';

@JsonSerializable()
class CommentsResponseModel {
  @JsonKey(name: 'items')
  final List<CommentItemModel>? items;
  @JsonKey(name: 'page')
  final int? page;
  @JsonKey(name: 'pageSize')
  final int? pageSize;
  @JsonKey(name: 'totalCount')
  final int? totalCount;
  @JsonKey(name: 'hasMore')
  final bool? hasMore;

  const CommentsResponseModel({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.hasMore,
  });

  factory CommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommentsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsResponseModelToJson(this);

  CommentsResponseEntity toEntity() {
    return CommentsResponseEntity(
      items: items?.map((e) => e.toEntity()).toList(),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }
}
