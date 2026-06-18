import 'package:json_annotation/json_annotation.dart';

part 'toggle_like_response.g.dart';

@JsonSerializable()
class ToggleLikeResponse {
  @JsonKey(name: 'isLiked')
  final bool? isLiked;
  @JsonKey(name: 'likesCount')
  final int? likesCount;
  @JsonKey(name: 'message')
  final String? message;

  const ToggleLikeResponse({this.isLiked, this.likesCount, this.message});

  factory ToggleLikeResponse.fromJson(Map<String, dynamic> json) =>
      _$ToggleLikeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ToggleLikeResponseToJson(this);
}
