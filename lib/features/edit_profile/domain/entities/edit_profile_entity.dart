class ProfileInfoEntity {
  final String firstName;
  final String lastName;
  final String userName;
  final String? phoneNumber;
  final String? bio;
  final String? profilePicture;
  final String? coverPicture;

  const ProfileInfoEntity({
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.phoneNumber = '',
    this.bio = '',
    this.profilePicture,
    this.coverPicture,
  });

  ProfileInfoEntity copyWith({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? bio,
    String? profilePicture,
    String? coverPicture,
  }) {
    return ProfileInfoEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      coverPicture: coverPicture ?? this.coverPicture,
    );
  }
}
