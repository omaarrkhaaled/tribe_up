import 'dart:io';

import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

sealed class FeedIntents {
  const FeedIntents();
}

final class SelectTabIntent extends FeedIntents {
  final FeedNavTab tab;
  const SelectTabIntent(this.tab);
}

final class LoadFeedIntent extends FeedIntents {
  const LoadFeedIntent();
}

final class RefreshFeedIntent extends FeedIntents {
  const RefreshFeedIntent();
}

final class LoadJoinedGroupsIntent extends FeedIntents {
  const LoadJoinedGroupsIntent();
}

final class LoadUserSummaryIntent extends FeedIntents {
  const LoadUserSummaryIntent();
}

final class DeletePostIntent extends FeedIntents {
  final int postId;
  const DeletePostIntent(this.postId);
}

final class ToggleLikeIntent extends FeedIntents {
  final int postId;
  const ToggleLikeIntent(this.postId);
}

final class PostCreatedIntent extends FeedIntents {
  final PostEntity post;
  const PostCreatedIntent(this.post);
}

final class EditPostIntent extends FeedIntents {
  final int postId;
  final String caption;
  final List<File>? newMediaFiles;
  final List<int>? deleteMediaIds;
  const EditPostIntent({
    required this.postId,
    required this.caption,
    this.newMediaFiles,
    this.deleteMediaIds,
  });
}
