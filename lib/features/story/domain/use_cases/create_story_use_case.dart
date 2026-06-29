import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/repository/story_repository.dart';

@lazySingleton
class CreateStoryUseCase {
  final StoryRepository _repository;

  const CreateStoryUseCase(this._repository);

  Future<BaseResponse<StoryEntity>> call({
    int? groupId,
    String? caption,
    required int accessibility,
    required File mediaFile,
  }) {
    return _repository.createStory(
      groupId: groupId,
      caption: caption,
      accessibility: accessibility,
      mediaFile: mediaFile,
    );
  }
}
