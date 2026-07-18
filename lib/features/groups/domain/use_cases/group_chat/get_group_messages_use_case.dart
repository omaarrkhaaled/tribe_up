import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/entities/chat_messages_response_entity.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_chat_repository.dart';

@injectable
class GetGroupMessagesUseCase {
  final GroupChatRepository _repository;

  GetGroupMessagesUseCase(this._repository);

  Future<BaseResponse<ChatMessagesResponseEntity>> call(
    int groupId,
    int page,
    int pageSize,
  ) {
    return _repository.getMessages(groupId, page, pageSize);
  }
}
