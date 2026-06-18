import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/group_chat/domain/repositories/group_chat_repository.dart';

@injectable
class SendGroupMessageUseCase {
  final GroupChatRepository _repository;

  SendGroupMessageUseCase(this._repository);

  Future<BaseResponse<ChatMessageEntity>> call(int groupId, String text) {
    return _repository.sendMessage(groupId, text);
  }
}
