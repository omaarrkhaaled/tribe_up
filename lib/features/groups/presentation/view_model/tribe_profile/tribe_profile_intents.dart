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
