import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@lazySingleton
class DeletePollUseCase {
  final PollsRepository repository;
  DeletePollUseCase(this.repository);

  Future<BaseResponse<void>> call({required int pollId}) async {
    return await repository.deletePoll(pollId);
  }
}
