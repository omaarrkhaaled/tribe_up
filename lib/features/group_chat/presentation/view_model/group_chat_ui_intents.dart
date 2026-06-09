import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

sealed class GroupChatUiIntents {}

class ShowMessageOptionsUiIntent extends GroupChatUiIntents {
  final ChatMessageEntity message;
  ShowMessageOptionsUiIntent({required this.message});
}

class ShowGroupChatLoadingIntent extends GroupChatUiIntents {
  ShowGroupChatLoadingIntent();
}

class ShowGroupChatErrorIntent extends GroupChatUiIntents {
  final String errorMessage;

  ShowGroupChatErrorIntent({required this.errorMessage});
}
