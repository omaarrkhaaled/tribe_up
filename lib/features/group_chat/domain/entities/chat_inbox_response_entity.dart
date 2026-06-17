import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';

class ChatInboxResponseEntity {
  final List<ChatInboxItemEntity> items;

  const ChatInboxResponseEntity({required this.items});
}
