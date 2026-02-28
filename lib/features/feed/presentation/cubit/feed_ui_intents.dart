sealed class FeedUiIntents {
  const FeedUiIntents();
}

final class ShowLoadingIntent extends FeedUiIntents {
  const ShowLoadingIntent();
}

final class ShowErrorIntent extends FeedUiIntents {
  final String message;
  const ShowErrorIntent(this.message);
}

final class NavigateToDetailIntent extends FeedUiIntents {
  final String postId;
  const NavigateToDetailIntent(this.postId);
}
