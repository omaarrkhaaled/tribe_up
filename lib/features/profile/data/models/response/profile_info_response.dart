import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
part 'profile_info_response.g.dart';

@JsonSerializable()
class ProfileInfoResponse {
  @JsonKey(name: 'firstName')
  String firstName;

  @JsonKey(name: 'lastName')
  String lastName;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'bio')
  String bio;

  @JsonKey(name: 'profilePicture')
  String profilePicture;

  @JsonKey(name: 'coverPicture')
  String coverPicture;

  ProfileInfoResponse({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.phoneNumber,
    required this.bio,
    required this.profilePicture,
    required this.coverPicture,
  });

  factory ProfileInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileInfoResponseToJson(this);

  ProfileInfoEntity toEntity() {
    return ProfileInfoEntity(
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      phoneNumber: phoneNumber,
      bio: bio,
      profilePicture: profilePicture,
      coverPicture: coverPicture,
    );
  }
}
