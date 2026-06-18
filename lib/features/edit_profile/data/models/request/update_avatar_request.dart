import 'package:json_annotation/json_annotation.dart';
part 'update_avatar_request.g.dart';

@JsonSerializable()
class UpdateAvatarRequest {
  @JsonKey(name: 'avatar')
  final String avatar;

  UpdateAvatarRequest({required this.avatar});

  factory UpdateAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAvatarRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAvatarRequestToJson(this);
}
