import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@lazySingleton
class UpdatePollUseCase {
  final PollsRepository repository;
  UpdatePollUseCase(this.repository);

  Future<BaseResponse<Poll>> call({
    required int pollId,
    required EditPollRequest request,
  }) async {
    return await repository.updatePoll(pollId, request);
  }
}
