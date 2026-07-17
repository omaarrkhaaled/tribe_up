class UserProfileEntity {
  final String id;
  final String fullName;
  final String userName;
  final String profilePicture;
  final String coverPicture;
  final String bio;
  final DateTime createdAt;
  final int tribesCount;
  final int postsCount;
  final bool isOwnProfile;

  const UserProfileEntity({
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
}
