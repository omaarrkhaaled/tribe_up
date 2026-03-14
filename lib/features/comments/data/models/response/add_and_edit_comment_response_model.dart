import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/comments/domain/entities/add_and_edit_comment_response_entity.dart';

import '../../../../feed/data/models/post_model.dart';
import 'comment_item_model.dart';

part 'add_and_edit_comment_response_model.g.dart';

@JsonSerializable()
class AddAndEditCommentResponseModel {
  @JsonKey(name: 'isCreated')
  final bool? isCreated;
  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'post')
  final PostModel? post;
  @JsonKey(name: 'comment')
  final CommentItemModel? comment;

  const AddAndEditCommentResponseModel({
    this.isCreated,
    this.status,
    this.message,
    this.post,
    this.comment,
  });

  factory AddAndEditCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddAndEditCommentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAndEditCommentResponseModelToJson(this);

  AddAndEditCommentResponseEntity toEntity() {
    return AddAndEditCommentResponseEntity(
      isCreated: isCreated,
      status: status,
      message: message,
      comment: comment?.toEntity(),
    );
  }
}
