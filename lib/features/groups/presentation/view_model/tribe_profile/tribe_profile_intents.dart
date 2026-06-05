import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

sealed class TribeProfileIntents {
  const TribeProfileIntents();
}

final class LoadTribeIntent extends TribeProfileIntents {
  final int groupId;
  final Group? initialGroup;
  const LoadTribeIntent(this.groupId, {this.initialGroup});
}

final class LoadTribePostsIntent extends TribeProfileIntents {
  final int groupId;
  final bool refresh;
  const LoadTribePostsIntent(this.groupId, {this.refresh = false});
}

final class AddCreatedPostIntent extends TribeProfileIntents {
  final PostEntity post;
  const AddCreatedPostIntent(this.post);
}

final class RefreshTribeIntent extends TribeProfileIntents {
  final int groupId;
  const RefreshTribeIntent(this.groupId);
}

final class LeaveGroupIntent extends TribeProfileIntents {
  const LeaveGroupIntent();
}

final class ToggleFollowIntent extends TribeProfileIntents {
  const ToggleFollowIntent();
}

final class OpenTribeSettingsIntent extends TribeProfileIntents {
  final Group tribe;
  const OpenTribeSettingsIntent(this.tribe);
}

/// (Admin only)
final class OpenInviteIntent extends TribeProfileIntents {
  const OpenInviteIntent();
}

final class LoadMoreTribePostsIntent extends TribeProfileIntents {
  final int groupId;
  const LoadMoreTribePostsIntent(this.groupId);
}

final class ToggleLikePostIntent extends TribeProfileIntents {
  final int postId;
  const ToggleLikePostIntent(this.postId);
}

final class DeletePostIntent extends TribeProfileIntents {
  final int postId;
  const DeletePostIntent(this.postId);
}

final class EditPostIntent extends TribeProfileIntents {
  final int postId;
  final String caption;
  final List<dynamic>? newMediaFiles;
  final List<int>? deleteMediaIds;

  const EditPostIntent({
    required this.postId,
    required this.caption,
    this.newMediaFiles,
    this.deleteMediaIds,
  });
}
