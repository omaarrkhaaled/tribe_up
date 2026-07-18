import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_members_repository.dart';

@lazySingleton
class GetGroupMembersUseCase {
  final GroupMembersRepository repository;
  GetGroupMembersUseCase(this.repository);

  Future<BaseResponse<GroupMemberResultDTOPagedResult>> call(
    int groupId,
    int page,
    int pageSize,
    String? search,
  ) async {
    return await repository.getGroupMembers(groupId, page, pageSize, search);
  }
}
