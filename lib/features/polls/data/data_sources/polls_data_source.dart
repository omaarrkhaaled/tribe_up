import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';

abstract class PollsDataSource {
  Future<BaseResponse<Poll>> createPoll(int groupId, CreatePollRequest request);
  Future<BaseResponse<PollsPagedResult>> getGroupPolls(
    int groupId,
    int? page,
    int? pageSize,
  );
  Future<BaseResponse<Poll>> getPollById(int pollId);
  Future<BaseResponse<Poll>> updatePoll(int pollId, EditPollRequest request);
  Future<BaseResponse<dynamic>> deletePoll(int pollId);
  Future<BaseResponse<ToggleVoteResult>> toggleVote(int pollId, int optionId);
}
