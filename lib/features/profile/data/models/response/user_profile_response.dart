import 'package:json_annotation/json_annotation.dart';
part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'fullName')
  String fullName;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'profilePicture')
  String profilePicture;

  @JsonKey(name: 'coverPicture')
  String coverPicture;

  @JsonKey(name: 'bio')
  String bio;

  @JsonKey(name: 'createdAt')
  DateTime createdAt;

  @JsonKey(name: 'tribesCount')
  int tribesCount;

  @JsonKey(name: 'postsCount')
  int postsCount;

  @JsonKey(name: 'isOwnProfile')
  bool isOwnProfile;

  UserProfileResponse({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.profilePicture,
    required this.coverPicture,
    required this.bio,
    required this.createdAt,
    required this.tribesCount,
    required this.postsCount,
    required this.isOwnProfile,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}
