import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

sealed class GroupChatIntents {
  const GroupChatIntents();
}

class ShowMessageOptionsIntent extends GroupChatIntents {
  final ChatMessageEntity message;
  const ShowMessageOptionsIntent({required this.message});
}

class GetGroupMessagesIntent extends GroupChatIntents {
  final int groupId;
  const GetGroupMessagesIntent({required this.groupId});
}

class SendGroupMessageIntent extends GroupChatIntents {
  final int groupId;
  final String text;

  const SendGroupMessageIntent({required this.groupId, required this.text});
}

class DeleteGroupMessageIntent extends GroupChatIntents {
  final int messageId;

  const DeleteGroupMessageIntent({required this.messageId});
}

class EditGroupMessageIntent extends GroupChatIntents {
  final int messageId;
  final String text;

  const EditGroupMessageIntent({required this.messageId, required this.text});
}

class LoadMoreGroupMessagesIntent extends GroupChatIntents {
  final int groupId;
  const LoadMoreGroupMessagesIntent({required this.groupId});
}

class StartEditMessageIntent extends GroupChatIntents {
  final int messageId;
  const StartEditMessageIntent({required this.messageId});
}

class CancelEditMessageIntent extends GroupChatIntents {
  const CancelEditMessageIntent();
}
