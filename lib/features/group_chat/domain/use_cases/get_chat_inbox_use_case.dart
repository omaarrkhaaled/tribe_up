import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_response_entity.dart';
import 'package:tribe_up/features/group_chat/domain/repositories/group_chat_repository.dart';

@injectable
class GetChatInboxUseCase {
  final GroupChatRepository _repository;

  GetChatInboxUseCase(this._repository);

  Future<BaseResponse<ChatInboxResponseEntity>> call(int page, int pageSize) {
    return _repository.getChatInbox(page, pageSize);
  }
}
