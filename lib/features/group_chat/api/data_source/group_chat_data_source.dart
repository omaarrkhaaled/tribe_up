import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/group_chat/api/api_client/group_chat_api_client.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_inbox_response.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_message_model.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_messages_response.dart';

abstract class GroupChatDataSource {
  Future<ChatMessagesResponse> getMessages(int groupId, int page, int pageSize);
  Future<ChatMessageModel> sendMessage(int groupId, String content);
  Future<ChatInboxResponse> getChatInbox();
  Future<ChatMessageModel> editMessage(int messageId, String content);
  Future<void> deleteMessage(int messageId);
}

@Injectable(as: GroupChatDataSource)
class GroupChatDataSourceImpl implements GroupChatDataSource {
  final GroupChatApiClient _apiClient;
  final Dio _dio;

  GroupChatDataSourceImpl(this._apiClient, this._dio);

  @override
  Future<ChatMessagesResponse> getMessages(
    int groupId,
    int page,
    int pageSize,
  ) {
    return _apiClient.getMessages(groupId, page, pageSize);
  }

  @override
  Future<ChatMessageModel> sendMessage(int groupId, String content) {
    return _apiClient.sendMessage(groupId, {'content': content});
  }

  @override
  Future<ChatInboxResponse> getChatInbox() async {
    // The /api/GroupChat/ChatInbox endpoint returns a plain JSON array,
    // not a paged wrapper, so we call Dio directly.
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.groupChatInboxEndPoint}',
    );
    return ChatInboxResponse.fromJson(response.data as List<dynamic>);
  }

  @override
  Future<ChatMessageModel> editMessage(int messageId, String content) {
    return _apiClient.editMessage(messageId, {'content': content});
  }

  @override
  Future<void> deleteMessage(int messageId) {
    return _apiClient.deleteMessage(messageId);
  }
}
