import 'package:tribe_up/features/groups/domain/entities/chat_message_entity.dart';

class ChatMessagesResponseEntity {
  final List<ChatMessageEntity> messages;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const ChatMessagesResponseEntity({
    required this.messages,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}
