import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class ProfileStates extends Equatable {
  final bool isLoadingProfile;
  final bool isLoadingPosts;
  final ProfileEntity? profile;
  final List<PostEntity> posts;

  const ProfileStates({
    this.isLoadingProfile = false,
    this.isLoadingPosts = false,
    this.profile,
    this.posts = const [],
  });

  ProfileStates copyWith({
    bool? isLoadingProfile,
    bool? isLoadingPosts,
    ProfileEntity? profile,
    List<PostEntity>? posts,
  }) {
    return ProfileStates(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object?> get props => [isLoadingProfile, isLoadingPosts, profile, posts];
}
