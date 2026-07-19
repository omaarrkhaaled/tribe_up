import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_members_repository.dart';

@lazySingleton
class PromoteMemberUseCase {
  final GroupMembersRepository repository;
  PromoteMemberUseCase(this.repository);

  Future<BaseResponse<bool>> call(int groupId, int groupMemberId) async {
    return await repository.promoteMember(groupId, groupMemberId);
  }
}
