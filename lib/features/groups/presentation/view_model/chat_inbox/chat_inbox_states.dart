import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_inbox_item_entity.dart';

class ChatInboxStates extends Equatable {
  final List<ChatInboxItemEntity> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String searchQuery;

  const ChatInboxStates({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.searchQuery = '',
  });

  List<ChatInboxItemEntity> get filteredItems {
    if (searchQuery.trim().isEmpty) return items;
    final q = searchQuery.toLowerCase();
    return items.where((item) {
      final nameMatch = item.groupName.toLowerCase().contains(q);
      final msgMatch =
          item.lastMessageContent?.toLowerCase().contains(q) ?? false;
      return nameMatch || msgMatch;
    }).toList();
  }

  ChatInboxStates copyWith({
    List<ChatInboxItemEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
  }) {
    return ChatInboxStates(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    items,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPage,
    searchQuery,
  ];
}
