import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/groups/api/api_client/group_invitations_api_client.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_invitations_data_source.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

@Injectable(as: GroupInvitationsDataSource)
class GroupInvitationsDataSourceImpl implements GroupInvitationsDataSource {
  final GroupInvitationsApiClient _apiClient;
  GroupInvitationsDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<InvitationResultDTO>> createInvitations(
    int groupId,
    CreateInvitationRequest request,
  ) {
    return safeApiCall(() => _apiClient.createInvitations(groupId, request));
  }

  @override
  Future<BaseResponse<InvitationDetailsDTO>> getInvitationDetails(
    String token,
  ) {
    return safeApiCall(() => _apiClient.getInvitationDetails(token));
  }

  @override
  Future<BaseResponse<AcceptInvitationResponseDTO>> acceptInvitation(
    String token,
  ) {
    return safeApiCall(() => _apiClient.acceptInvitation(token));
  }

  @override
  Future<BaseResponse<InvitationResultDTO>> getActiveInvitation(int groupId) {
    return safeApiCall(() => _apiClient.getActiveInvitation(groupId));
  }

  @override
  Future<BaseResponse<bool>> revokeInvitation(int invitationId) {
    return safeApiCall(() => _apiClient.revokeInvitation(invitationId));
  }
}
