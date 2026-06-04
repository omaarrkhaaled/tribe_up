import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class FeedStates extends BaseState<void> {
  final FeedNavTab currentTab;
  final List<PostEntity> posts;

  // Joined groups for create-post trigger
  final List<Group> joinedGroups;
  final bool isLoadingGroups;

  // Post actions in-progress
  final Set<int> togglingLikePostIds;
  final Set<int> deletingPostIds;
  final Set<int> editingPostIds;

  const FeedStates({
    this.currentTab = FeedNavTab.feed,
    this.posts = const [],
    this.joinedGroups = const [],
    this.isLoadingGroups = false,
    this.togglingLikePostIds = const {},
    this.deletingPostIds = const {},
    this.editingPostIds = const {},
    super.isLoading = false,
    super.errorMessage,
  });

  FeedStates copyWith({
    FeedNavTab? currentTab,
    List<PostEntity>? posts,
    List<Group>? joinedGroups,
    bool? isLoadingGroups,
    Set<int>? togglingLikePostIds,
    Set<int>? deletingPostIds,
    Set<int>? editingPostIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FeedStates(
      currentTab: currentTab ?? this.currentTab,
      posts: posts ?? this.posts,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      isLoadingGroups: isLoadingGroups ?? this.isLoadingGroups,
      togglingLikePostIds: togglingLikePostIds ?? this.togglingLikePostIds,
      deletingPostIds: deletingPostIds ?? this.deletingPostIds,
      editingPostIds: editingPostIds ?? this.editingPostIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (error ?? errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    currentTab,
    posts,
    joinedGroups,
    isLoadingGroups,
    togglingLikePostIds,
    deletingPostIds,
    editingPostIds,
    isLoading,
    errorMessage,
  ];
}
