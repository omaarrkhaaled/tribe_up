import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@lazySingleton
class GetGroupStoriesUseCase {
  final StoryRepository _repository;

  const GetGroupStoriesUseCase(this._repository);

  Future<BaseResponse<List<StoryEntity>>> call({required int groupId}) {
    return _repository.getGroupStories(groupId: groupId);
  }
}
