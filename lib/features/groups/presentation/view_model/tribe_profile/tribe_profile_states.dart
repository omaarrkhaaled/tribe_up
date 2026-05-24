import 'package:equatable/equatable.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class TribeProfileState extends Equatable {
  final Group? tribe;
  final bool isLoading;
  final bool isActionLoading; // join/leave/follow in progress
  final String? errorMessage;

  // Post Feed related
  final List<PostEntity> posts;
  final bool isLoadingPosts;
  final String? postsErrorMessage;
  final bool hasMorePosts;
  final int postsPage;

  const TribeProfileState({
    this.tribe,
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.posts = const [],
    this.isLoadingPosts = false,
    this.postsErrorMessage,
    this.hasMorePosts = true,
    this.postsPage = 1,
  });

  UserRelation get userRelation => UserRelation.fromInt(tribe?.userRelation);

  TribeProfileState copyWith({
    Group? tribe,
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    bool clearError = false,
    List<PostEntity>? posts,
    bool? isLoadingPosts,
    String? postsErrorMessage,
    bool clearPostsError = false,
    bool? hasMorePosts,
    int? postsPage,
  }) {
    return TribeProfileState(
      tribe: tribe ?? this.tribe,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      posts: posts ?? this.posts,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
      postsErrorMessage: clearPostsError
          ? null
          : (postsErrorMessage ?? this.postsErrorMessage),
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      postsPage: postsPage ?? this.postsPage,
    );
  }

  @override
  List<Object?> get props => [
    tribe,
    isLoading,
    isActionLoading,
    errorMessage,
    posts,
    isLoadingPosts,
    postsErrorMessage,
    hasMorePosts,
    postsPage,
  ];
}
