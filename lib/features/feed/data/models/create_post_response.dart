import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/feed/data/models/post_model.dart';

part 'create_post_response.g.dart';

@JsonSerializable()
class CreatePostResponse {
  @JsonKey(name: 'isCreated')
  final bool isCreated;
  @JsonKey(name: 'status')
  final int status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'post')
  final PostModel post;

  CreatePostResponse({
    required this.isCreated,
    required this.status,
    required this.message,
    required this.post,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostResponseToJson(this);
}
