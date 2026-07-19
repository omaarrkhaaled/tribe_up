import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_invitations_repository.dart';

@lazySingleton
class RevokeInvitationUseCase {
  final GroupInvitationsRepository repository;
  RevokeInvitationUseCase(this.repository);

  Future<BaseResponse<bool>> call(int invitationId) async {
    return await repository.revokeInvitation(invitationId);
  }
}
