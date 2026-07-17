import 'dart:io';

sealed class ProfileIntents {}

class GetProfileDetailsIntent extends ProfileIntents {
  final String userName;
  GetProfileDetailsIntent({required this.userName});
}

class GetPersonalPostsIntent extends ProfileIntents {
  final String userName;
  GetPersonalPostsIntent({required this.userName});
}

class ToggleLikeIntent extends ProfileIntents {
  final int postId;
  ToggleLikeIntent(this.postId);
}

class DeletePostIntent extends ProfileIntents {
  final int postId;
  DeletePostIntent(this.postId);
}

class EditPostIntent extends ProfileIntents {
  final int postId;
  final String caption;
  final List<File>? newMediaFiles;
  final List<int>? deleteMediaIds;
  EditPostIntent({
    required this.postId,
    required this.caption,
    this.newMediaFiles,
    this.deleteMediaIds,
  });
}
