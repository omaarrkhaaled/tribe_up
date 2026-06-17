import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_messages_response_entity.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_response_entity.dart';

abstract class GroupChatRepository {
  Future<BaseResponse<ChatMessagesResponseEntity>> getMessages(
    int groupId,
    int page,
    int pageSize,
  );
  Future<BaseResponse<ChatMessageEntity>> sendMessage(
    int groupId,
    String content,
  );
  Future<BaseResponse<ChatInboxResponseEntity>> getChatInbox();
  Future<BaseResponse<ChatMessageEntity>> editMessage(
    int messageId,
    String content,
  );
  Future<BaseResponse<void>> deleteMessage(int messageId);
}
