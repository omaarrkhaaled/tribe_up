import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

part 'group_invitations_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GroupInvitationsApiClient {
  @factoryMethod
  factory GroupInvitationsApiClient(Dio dio) = _GroupInvitationsApiClient;

  @POST(ApiConstants.groupCreateInvitationsEndPoint)
  Future<InvitationResultDTO> createInvitations(
    @Path("groupId") int groupId,
    @Body() CreateInvitationRequest request,
  );

  @GET(ApiConstants.groupInvitationDetailsEndPoint)
  Future<InvitationDetailsDTO> getInvitationDetails(
    @Path("token") String token,
  );

  @POST(ApiConstants.groupAcceptInvitationsEndPoint)
  Future<AcceptInvitationResponseDTO> acceptInvitation(
    @Path("token") String token,
  );

  @GET(ApiConstants.groupGetActiveInvitationEndPoint)
  Future<InvitationResultDTO> getActiveInvitation(@Path("groupId") int groupId);

  @DELETE(ApiConstants.groupRevokeInvitationEndPoint)
  Future<bool> revokeInvitation(@Path("invitationId") int invitationId);
}
