import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class ExploreGroupsUseCase {
  final GroupsRepository repository;

  ExploreGroupsUseCase(this.repository);

  Future<BaseResponse<GroupsResponse>> call(
    int? page,
    int? pageSize,
    String? search,
  ) async {
    return await repository.exploreGroups(page, pageSize, search);
  }
}
