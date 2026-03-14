import 'package:json_annotation/json_annotation.dart';

part 'edit_comment_request_model.g.dart';

@JsonSerializable()
class EditCommentRequestModel {
  @JsonKey(name: 'Content')
  final String content;

  @JsonKey(name: 'TaggedUserIds')
  final List<String>? taggedUserIds;

  const EditCommentRequestModel({required this.content, this.taggedUserIds});

  Map<String, dynamic> toJson() => _$EditCommentRequestModelToJson(this);

  factory EditCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditCommentRequestModelFromJson(json);
}
