import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/group_chat/api/api_client/group_chat_api_client.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_message_model.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_messages_response.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_inbox_response.dart';

abstract class GroupChatDataSource {
  Future<ChatMessagesResponse> getMessages(int groupId, int page, int pageSize);
  Future<ChatMessageModel> sendMessage(int groupId, String text);
  Future<ChatInboxResponse> getChatInbox(int page, int pageSize);
  Future<ChatMessageModel> editMessage(int messageId, String text);
  Future<void> deleteMessage(int messageId);
}

@Injectable(as: GroupChatDataSource)
class GroupChatDataSourceImpl implements GroupChatDataSource {
  final GroupChatApiClient _apiClient;

  GroupChatDataSourceImpl(this._apiClient);

  @override
  Future<ChatMessagesResponse> getMessages(
    int groupId,
    int page,
    int pageSize,
  ) {
    return _apiClient.getMessages(groupId, page, pageSize);
  }

  @override
  Future<ChatMessageModel> sendMessage(int groupId, String text) {
    return _apiClient.sendMessage(groupId, {'text': text});
  }

  @override
  Future<ChatInboxResponse> getChatInbox(int page, int pageSize) {
    return _apiClient.getChatInbox(page, pageSize);
  }

  @override
  Future<ChatMessageModel> editMessage(int messageId, String text) {
    return _apiClient.editMessage(messageId, {'text': text});
  }

  @override
  Future<void> deleteMessage(int messageId) {
    return _apiClient.deleteMessage(messageId);
  }
}
