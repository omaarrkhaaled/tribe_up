import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@lazySingleton
class ToggleVoteUseCase {
  final PollsRepository repository;
  ToggleVoteUseCase(this.repository);

  Future<BaseResponse<ToggleVoteResult>> call({
    required int pollId,
    required int optionId,
  }) async {
    return await repository.toggleVote(pollId, optionId);
  }
}
