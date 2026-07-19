import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/groups/api/data_sources/group_chat_data_source.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_messages_response_entity.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_inbox_response_entity.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_chat_repository.dart';

@Injectable(as: GroupChatRepository)
class GroupChatRepositoryImpl implements GroupChatRepository {
  final GroupChatDataSource _dataSource;

  GroupChatRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<ChatMessagesResponseEntity>> getMessages(
    int groupId,
    int page,
    int pageSize,
  ) async {
    return safeApiCall<ChatMessagesResponseEntity>(() async {
      final response = await _dataSource.getMessages(groupId, page, pageSize);
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<ChatMessageEntity>> sendMessage(
    int groupId,
    String content,
  ) async {
    return safeApiCall<ChatMessageEntity>(() async {
      final response = await _dataSource.sendMessage(groupId, content);
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<ChatInboxResponseEntity>> getChatInbox() async {
    return safeApiCall<ChatInboxResponseEntity>(() async {
      final response = await _dataSource.getChatInbox();
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<ChatMessageEntity>> editMessage(
    int messageId,
    String content,
  ) async {
    return safeApiCall<ChatMessageEntity>(() async {
      final response = await _dataSource.editMessage(messageId, content);
      return response.toEntity();
    });
  }

  @override
  Future<BaseResponse<void>> deleteMessage(int messageId) async {
    return safeApiCall<void>(() async {
      await _dataSource.deleteMessage(messageId);
    });
  }
}
