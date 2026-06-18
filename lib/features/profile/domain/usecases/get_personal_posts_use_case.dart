import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/feed_response_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@lazySingleton
class GetPersonalPostsUseCase {
  final FeedRepository repository;

  GetPersonalPostsUseCase(this.repository);

  Future<BaseResponse<FeedResponseEntity>> call({
    required String userName,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await repository.getPersonalFeedPosts(
      username: userName,
      page: page,
      pageSize: pageSize,
    );
  }
}
