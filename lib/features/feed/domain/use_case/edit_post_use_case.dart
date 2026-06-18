import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@lazySingleton
class EditPostUseCase {
  final FeedRepository _repository;

  const EditPostUseCase(this._repository);

  Future<BaseResponse<PostEntity>> call({
    required int postId,
    required String caption,
    int? groupId,
    int? accessibility,
    List<String>? taggedUserIds,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  }) {
    return _repository.editPost(
      postId: postId,
      caption: caption,
      groupId: groupId,
      accessibility: accessibility,
      taggedUserIds: taggedUserIds,
      newMediaFiles: newMediaFiles,
      deleteMediaIds: deleteMediaIds,
    );
  }
}
