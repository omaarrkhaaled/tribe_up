import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@lazySingleton
class DeleteStoryUseCase {
  final StoryRepository _repository;

  const DeleteStoryUseCase(this._repository);

  Future<BaseResponse<bool>> call({required int storyId}) {
    return _repository.deleteStory(storyId: storyId);
  }
}
