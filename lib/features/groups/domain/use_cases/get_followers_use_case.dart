import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/group_followers_repository.dart';

@lazySingleton
class GetFollowersUseCase {
  final GroupFollowersRepository repository;
  GetFollowersUseCase(this.repository);

  Future<BaseResponse<GroupFollowerResultDTOPagedResult>> call(
    int groupId,
    int page,
    int pageSize,
    String? searchTerm,
  ) async {
    return await repository.getFollowers(groupId, page, pageSize, searchTerm);
  }
}
