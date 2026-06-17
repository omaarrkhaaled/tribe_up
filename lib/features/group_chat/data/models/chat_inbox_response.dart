import 'package:tribe_up/features/group_chat/data/models/chat_inbox_item_model.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_response_entity.dart';

/// The /api/GroupChat/ChatInbox endpoint returns a plain JSON array,
/// not a paged wrapper. This class wraps the list for use in the repository.
class ChatInboxResponse {
  final List<ChatInboxItemModel> items;

  const ChatInboxResponse({required this.items});

  factory ChatInboxResponse.fromJson(List<dynamic> json) {
    return ChatInboxResponse(
      items: json
          .map((e) => ChatInboxItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ChatInboxResponseEntity toEntity() {
    return ChatInboxResponseEntity(
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}
