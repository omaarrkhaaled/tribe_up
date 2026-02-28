import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@injectable
class FeedUseCase {
  final FeedRepository _repository;

  const FeedUseCase(this._repository);

  Future<BaseResponse> call({int page = 1, int pageSize = 20}) {
    return _repository.getFeedPosts(page: page, pageSize: pageSize);
  }
}
