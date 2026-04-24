import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'fullName')
  String fullName;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'profilePicture')
  String profilePicture;

  @JsonKey(name: 'coverPicture')
  String? coverPicture;

  @JsonKey(name: 'bio')
  String? bio;

  @JsonKey(name: 'createdAt')
  String createdAt;

  @JsonKey(name: 'tribesCount')
  int tribesCount;

  @JsonKey(name: 'postsCount')
  int postsCount;

  @JsonKey(name: 'isOwnProfile')
  bool isOwnProfile;

  ProfileResponse({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.profilePicture,
    this.coverPicture,
    this.bio,
    required this.createdAt,
    required this.tribesCount,
    required this.postsCount,
    required this.isOwnProfile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      fullName: fullName,
      userName: userName,
      profilePicture: profilePicture,
      coverPicture: coverPicture,
      bio: bio,
      createdAt: createdAt,
      tribesCount: tribesCount,
      postsCount: postsCount,
      isOwnProfile: isOwnProfile,
    );
  }
}
