import 'package:json_annotation/json_annotation.dart';
part 'my_profile_response.g.dart';

@JsonSerializable()
class MyProfileResponse {
  @JsonKey(name: 'fullName')
  final String fullName;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'profilePicture')
  final String profilePicture;

  @JsonKey(name: 'avatar')
  final String avatar;

  const MyProfileResponse({
    required this.fullName,
    required this.email,
    required this.profilePicture,
    required this.avatar,
  });

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyProfileResponseToJson(this);
}
