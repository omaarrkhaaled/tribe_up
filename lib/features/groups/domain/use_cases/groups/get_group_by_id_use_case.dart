import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class GetGroupByIdUseCase {
  final GroupsRepository repository;

  GetGroupByIdUseCase(this.repository);

  Future<BaseResponse<Group>> call(int id) async {
    return await repository.getGroupById(id);
  }
}
