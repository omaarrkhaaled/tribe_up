import 'package:tribe_up/features/groups/domain/entities/chat_inbox_item_entity.dart';

class ChatInboxResponseEntity {
  final List<ChatInboxItemEntity> items;

  const ChatInboxResponseEntity({required this.items});
}
