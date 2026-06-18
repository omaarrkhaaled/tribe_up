import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';

part 'group_followers_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GroupFollowersApiClient {
  @factoryMethod
  factory GroupFollowersApiClient(Dio dio) = _GroupFollowersApiClient;

  @GET(ApiConstants.groupFollowersEndPoint)
  Future<GroupFollowerResultDTOPagedResult> getFollowers(
    @Path("groupId") int groupId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("searchTerm") String? searchTerm,
  );

  @POST(ApiConstants.groupToggleFollowEndPoint)
  Future<FollowActionResponseDTO> toggleFollow(@Path("groupId") int groupId);

  @DELETE(ApiConstants.groupDeleteFollowerEndPoint)
  Future<bool> deleteFollower(
    @Path("groupId") int groupId,
    @Path("followerId") String followerId,
  );
}
