import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_invitations_repository.dart';

@lazySingleton
class CreateInvitationsUseCase {
  final GroupInvitationsRepository repository;
  CreateInvitationsUseCase(this.repository);

  Future<BaseResponse<InvitationResultDTO>> call(
    int groupId,
    CreateInvitationRequest request,
  ) async {
    return await repository.createInvitations(groupId, request);
  }
}
