import 'package:json_annotation/json_annotation.dart';

part 'delete_post_response.g.dart';

@JsonSerializable()
class DeletePostResponse {
  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;
  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'message')
  final String? message;

  const DeletePostResponse({this.isDeleted, this.status, this.message});

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletePostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePostResponseToJson(this);
}
