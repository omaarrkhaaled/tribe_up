import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';

part 'polls_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class PollsApiClient {
  @factoryMethod
  factory PollsApiClient(Dio dio) = _PollsApiClient;

  @POST(ApiConstants.createPollEndPoint)
  Future<Poll> createPoll(
    @Path("groupId") int groupId,
    @Body() CreatePollRequest request,
  );

  @GET(ApiConstants.groupPollsEndPoint)
  Future<PollsPagedResult> getGroupPolls(
    @Path("groupId") int groupId,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  );

  @GET(ApiConstants.getPollByIdEndPoint)
  Future<Poll> getPollById(@Path("pollId") int pollId);

  @PUT(ApiConstants.updatePollEndPoint)
  Future<Poll> updatePoll(
    @Path("pollId") int pollId,
    @Body() EditPollRequest request,
  );

  @DELETE(ApiConstants.deletePollEndPoint)
  Future<dynamic> deletePoll(@Path("pollId") int pollId);

  @POST(ApiConstants.toggleVoteEndPoint)
  Future<ToggleVoteResult> toggleVote(
    @Path("pollId") int pollId,
    @Path("optionId") int optionId,
  );
}
