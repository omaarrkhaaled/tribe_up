import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/polls/data/api_client/polls_api_client.dart';
import 'package:tribe_up/features/polls/data/data_sources/polls_data_source.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';

@Injectable(as: PollsDataSource)
class PollsDataSourceImpl implements PollsDataSource {
  final PollsApiClient _apiClient;

  PollsDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<Poll>> createPoll(
    int groupId,
    CreatePollRequest request,
  ) {
    return safeApiCall(() => _apiClient.createPoll(groupId, request));
  }

  @override
  Future<BaseResponse<PollsPagedResult>> getGroupPolls(
    int groupId,
    int? page,
    int? pageSize,
  ) {
    return safeApiCall(() => _apiClient.getGroupPolls(groupId, page, pageSize));
  }

  @override
  Future<BaseResponse<Poll>> getPollById(int pollId) {
    return safeApiCall(() => _apiClient.getPollById(pollId));
  }

  @override
  Future<BaseResponse<Poll>> updatePoll(int pollId, EditPollRequest request) {
    return safeApiCall(() => _apiClient.updatePoll(pollId, request));
  }

  @override
  Future<BaseResponse<dynamic>> deletePoll(int pollId) {
    return safeApiCall(() => _apiClient.deletePoll(pollId));
  }

  @override
  Future<BaseResponse<ToggleVoteResult>> toggleVote(int pollId, int optionId) {
    return safeApiCall(() => _apiClient.toggleVote(pollId, optionId));
  }
}
