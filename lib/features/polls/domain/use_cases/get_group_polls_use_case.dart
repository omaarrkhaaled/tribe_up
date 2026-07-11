import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';
import 'package:tribe_up/features/polls/domain/repositories/polls_repository.dart';

@lazySingleton
class GetGroupPollsUseCase {
  final PollsRepository repository;
  GetGroupPollsUseCase(this.repository);

  Future<BaseResponse<PollsPagedResult>> call({
    required int groupId,
    int? page,
    int? pageSize,
  }) async {
    return await repository.getGroupPolls(groupId, page, pageSize);
  }
}
