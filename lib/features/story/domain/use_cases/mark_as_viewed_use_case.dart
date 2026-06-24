import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@lazySingleton
class MarkAsViewedUseCase {
  final StoryRepository _repository;

  const MarkAsViewedUseCase(this._repository);

  Future<BaseResponse<bool>> call({required int storyId}) {
    return _repository.markAsViewed(storyId: storyId);
  }
}
