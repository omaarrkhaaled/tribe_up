import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@injectable
class GetGroupFeedUseCase {
  final FeedRepository _repository;

  const GetGroupFeedUseCase(this._repository);

  Future<BaseResponse<FeedResponseEntity>> call({
    required int groupId,
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getGroupFeedPosts(
      groupId: groupId,
      page: page,
      pageSize: pageSize,
    );
  }
}
