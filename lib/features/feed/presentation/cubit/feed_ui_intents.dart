import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

sealed class FeedUiIntents {
  const FeedUiIntents();
}

final class ShowLoadingUiIntent extends FeedUiIntents {
  const ShowLoadingUiIntent();
}

final class ShowErrorUiIntent extends FeedUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class ShowSuccessUiIntent extends FeedUiIntents {
  final String message;
  const ShowSuccessUiIntent(this.message);
}

final class NavigateToDetailUiIntent extends FeedUiIntents {
  final int postId;
  const NavigateToDetailUiIntent(this.postId);
}

final class ShowDeletePostDialogUiIntent extends FeedUiIntents {
  final PostEntity post;
  const ShowDeletePostDialogUiIntent(this.post);
}
