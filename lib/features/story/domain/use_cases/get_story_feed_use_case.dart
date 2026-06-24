import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@lazySingleton
class GetStoryFeedUseCase {
  final StoryRepository _repository;

  const GetStoryFeedUseCase(this._repository);

  Future<BaseResponse<List<StoryFeedItemEntity>>> call({
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    return _repository.getStoryFeed(pageNumber: pageNumber, pageSize: pageSize);
  }
}
