import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@lazySingleton
class CreatePollUseCase {
  final PollsRepository repository;
  CreatePollUseCase(this.repository);

  Future<BaseResponse<Poll>> call({
    required int groupId,
    required CreatePollRequest request,
  }) async {
    return await repository.createPoll(groupId, request);
  }
}
