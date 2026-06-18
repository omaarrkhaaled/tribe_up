import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/group_chat/domain/repositories/group_chat_repository.dart';

@injectable
class EditGroupMessageUseCase {
  final GroupChatRepository _repository;

  EditGroupMessageUseCase(this._repository);

  Future<BaseResponse<ChatMessageEntity>> call(int messageId, String text) {
    return _repository.editMessage(messageId, text);
  }
}
