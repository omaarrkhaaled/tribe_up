import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';

class ChatInboxResponseEntity {
  final List<ChatInboxItemEntity> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const ChatInboxResponseEntity({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}
