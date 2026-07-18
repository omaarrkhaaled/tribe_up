import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_invitations_repository.dart';

@lazySingleton
class GetActiveInvitationUseCase {
  final GroupInvitationsRepository repository;
  GetActiveInvitationUseCase(this.repository);

  Future<BaseResponse<InvitationResultDTO>> call(int groupId) async {
    return await repository.getActiveInvitation(groupId);
  }
}
