import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class UpdateGroupUseCase {
  final GroupsRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<BaseResponse<Group>> call({
    required int id,
    required UpdateGroupRequest request,
  }) async {
    return await repository.updateGroup(id, request);
  }
}
