import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_members_repository.dart';

@lazySingleton
class LeaveGroupUseCase {
  final GroupMembersRepository repository;
  LeaveGroupUseCase(this.repository);

  Future<BaseResponse<bool>> call(int groupId) async {
    return await repository.leaveGroup(groupId);
  }
}
