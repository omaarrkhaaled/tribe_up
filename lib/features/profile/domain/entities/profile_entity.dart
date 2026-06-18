import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String userName;
  final String profilePicture;
  final String? coverPicture;
  final String? bio;
  final String createdAt;
  final int tribesCount;
  final int postsCount;
  final bool isOwnProfile;

  const ProfileEntity({
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

  @override
  List<Object?> get props => [
    id,
    fullName,
    userName,
    profilePicture,
    coverPicture,
    bio,
    createdAt,
    tribesCount,
    postsCount,
    isOwnProfile,
  ];
}
