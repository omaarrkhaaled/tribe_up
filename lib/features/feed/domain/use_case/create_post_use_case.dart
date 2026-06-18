import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@injectable
class CreatePostUseCase {
  final FeedRepository _repository;

  const CreatePostUseCase(this._repository);

  Future<BaseResponse<PostEntity>> call({
    int? groupId,
    required String caption,
    required int accessibility,
    List<String>? taggedUserIds,
    List<File>? mediaFiles,
  }) async {
    return await _repository.createPost(
      groupId: groupId,
      caption: caption,
      accessibility: accessibility,
      taggedUserIds: taggedUserIds,
      mediaFiles: mediaFiles,
    );
  }
}
