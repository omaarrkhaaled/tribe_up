import 'package:equatable/equatable.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class TribesState extends Equatable {
  final TribesTab currentTab;

  // --- Joined In ---
  final List<Group> joinedTribes;
  final int joinedPage;
  final bool hasMoreJoined;
  final bool isLoadingJoined;

  // --- Discover ---
  final List<Group> discoverTribes;
  final int discoverPage;
  final bool hasMoreDiscover;
  final bool isLoadingDiscover;
  final String searchQuery;

  // --- Following ---
  final List<Group> followingTribes;
  final int followingPage;
  final bool hasMoreFollowing;
  final bool isLoadingFollowing;

  // --- Shared ---
  final bool isLoadingMore;
  final String? errorMessage;

  final Set<int> pendingActionIds;

  const TribesState({
    this.currentTab = TribesTab.joined,
    this.joinedTribes = const [],
    this.joinedPage = 1,
    this.hasMoreJoined = true,
    this.isLoadingJoined = false,
    this.discoverTribes = const [],
    this.discoverPage = 1,
    this.hasMoreDiscover = true,
    this.isLoadingDiscover = false,
    this.searchQuery = '',
    this.followingTribes = const [],
    this.followingPage = 1,
    this.hasMoreFollowing = true,
    this.isLoadingFollowing = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.pendingActionIds = const {},
  });

  TribesState copyWith({
    TribesTab? currentTab,
    List<Group>? joinedTribes,
    int? joinedPage,
    bool? hasMoreJoined,
    bool? isLoadingJoined,
    List<Group>? discoverTribes,
    int? discoverPage,
    bool? hasMoreDiscover,
    bool? isLoadingDiscover,
    String? searchQuery,
    List<Group>? followingTribes,
    int? followingPage,
    bool? hasMoreFollowing,
    bool? isLoadingFollowing,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    Set<int>? pendingActionIds,
  }) {
    return TribesState(
      currentTab: currentTab ?? this.currentTab,
      joinedTribes: joinedTribes ?? this.joinedTribes,
      joinedPage: joinedPage ?? this.joinedPage,
      hasMoreJoined: hasMoreJoined ?? this.hasMoreJoined,
      isLoadingJoined: isLoadingJoined ?? this.isLoadingJoined,
      discoverTribes: discoverTribes ?? this.discoverTribes,
      discoverPage: discoverPage ?? this.discoverPage,
      hasMoreDiscover: hasMoreDiscover ?? this.hasMoreDiscover,
      isLoadingDiscover: isLoadingDiscover ?? this.isLoadingDiscover,
      searchQuery: searchQuery ?? this.searchQuery,
      followingTribes: followingTribes ?? this.followingTribes,
      followingPage: followingPage ?? this.followingPage,
      hasMoreFollowing: hasMoreFollowing ?? this.hasMoreFollowing,
      isLoadingFollowing: isLoadingFollowing ?? this.isLoadingFollowing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingActionIds: pendingActionIds ?? this.pendingActionIds,
    );
  }

  @override
  List<Object?> get props => [
    currentTab,
    joinedTribes,
    joinedPage,
    hasMoreJoined,
    isLoadingJoined,
    discoverTribes,
    discoverPage,
    hasMoreDiscover,
    isLoadingDiscover,
    searchQuery,
    followingTribes,
    followingPage,
    hasMoreFollowing,
    isLoadingFollowing,
    isLoadingMore,
    errorMessage,
    pendingActionIds,
  ];
}
