import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class ProfileStates extends Equatable {
  final bool isLoadingProfile;
  final bool isLoadingPosts;
  final ProfileEntity? profile;
  final List<PostEntity> posts;
  final Set<int> togglingLikePostIds;
  final Set<int> deletingPostIds;
  final Set<int> editingPostIds;

  const ProfileStates({
    this.isLoadingProfile = false,
    this.isLoadingPosts = false,
    this.profile,
    this.posts = const [],
    this.togglingLikePostIds = const {},
    this.deletingPostIds = const {},
    this.editingPostIds = const {},
  });

  ProfileStates copyWith({
    bool? isLoadingProfile,
    bool? isLoadingPosts,
    ProfileEntity? profile,
    List<PostEntity>? posts,
    Set<int>? togglingLikePostIds,
    Set<int>? deletingPostIds,
    Set<int>? editingPostIds,
  }) {
    return ProfileStates(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      togglingLikePostIds: togglingLikePostIds ?? this.togglingLikePostIds,
      deletingPostIds: deletingPostIds ?? this.deletingPostIds,
      editingPostIds: editingPostIds ?? this.editingPostIds,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingProfile,
    isLoadingPosts,
    profile,
    posts,
    togglingLikePostIds,
    deletingPostIds,
    editingPostIds,
  ];
}
