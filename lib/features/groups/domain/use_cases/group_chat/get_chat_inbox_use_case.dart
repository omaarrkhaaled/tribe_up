import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_inbox_response_entity.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_chat_repository.dart';

@injectable
class GetChatInboxUseCase {
  final GroupChatRepository _repository;

  GetChatInboxUseCase(this._repository);

  Future<BaseResponse<ChatInboxResponseEntity>> call() {
    return _repository.getChatInbox();
  }
}
