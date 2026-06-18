import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

abstract class GroupInvitationsRepository {
  Future<BaseResponse<InvitationResultDTO>> createInvitations(
    int groupId,
    CreateInvitationRequest request,
  );
  Future<BaseResponse<InvitationDetailsDTO>> getInvitationDetails(String token);
  Future<BaseResponse<AcceptInvitationResponseDTO>> acceptInvitation(
    String token,
  );
  Future<BaseResponse<InvitationResultDTO>> getActiveInvitation(int groupId);
  Future<BaseResponse<bool>> revokeInvitation(int invitationId);
}
