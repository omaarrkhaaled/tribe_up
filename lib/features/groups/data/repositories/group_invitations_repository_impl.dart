import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/data_sources/group_invitations_data_source.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_invitations_repository.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

@LazySingleton(as: GroupInvitationsRepository)
class GroupInvitationsRepositoryImpl implements GroupInvitationsRepository {
  final GroupInvitationsDataSource _dataSource;
  GroupInvitationsRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<InvitationResultDTO>> createInvitations(
    int groupId,
    CreateInvitationRequest request,
  ) async {
    final response = await _dataSource.createInvitations(groupId, request);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<InvitationDetailsDTO>> getInvitationDetails(
    String token,
  ) async {
    final response = await _dataSource.getInvitationDetails(token);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<AcceptInvitationResponseDTO>> acceptInvitation(
    String token,
  ) async {
    final response = await _dataSource.acceptInvitation(token);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<InvitationResultDTO>> getActiveInvitation(
    int groupId,
  ) async {
    final response = await _dataSource.getActiveInvitation(groupId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<bool>> revokeInvitation(int invitationId) async {
    final response = await _dataSource.revokeInvitation(invitationId);
    switch (response) {
      case SuccessResponse(data: var data):
        return SuccessResponse(data: data);
      case ErrorResponse(error: var error):
        return ErrorResponse(error: error);
    }
  }
}
