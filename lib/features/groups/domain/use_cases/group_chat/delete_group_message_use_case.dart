import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_chat_repository.dart';

@injectable
class DeleteGroupMessageUseCase {
  final GroupChatRepository _repository;

  DeleteGroupMessageUseCase(this._repository);

  Future<BaseResponse<void>> call(int messageId) {
    return _repository.deleteMessage(messageId);
  }
}
