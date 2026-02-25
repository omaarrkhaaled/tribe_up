import 'package:tribe_up/core/enums/feed_nav_tab.dart';

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
