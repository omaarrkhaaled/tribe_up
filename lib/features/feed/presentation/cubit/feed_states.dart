import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class FeedStates extends BaseState<void> {
  final FeedNavTab currentTab;
  final List<PostEntity> posts;

  const FeedStates({
    this.currentTab = FeedNavTab.feed,
    this.posts = const [],
    super.isLoading = false,
    super.errorMessage,
  });

  FeedStates copyWith({
    FeedNavTab? currentTab,
    List<PostEntity>? posts,
    bool? isLoading,
    String? error,
  }) {
    return FeedStates(
      currentTab: currentTab ?? this.currentTab,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: error,
    );
  }

  @override
  List<Object?> get props => [currentTab, posts, isLoading, errorMessage];
}
