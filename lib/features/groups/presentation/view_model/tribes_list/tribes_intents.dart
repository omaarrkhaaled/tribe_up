import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

sealed class TribesIntents {
  const TribesIntents();
}

final class LoadJoinedTribesIntent extends TribesIntents {
  const LoadJoinedTribesIntent();
}

final class LoadDiscoverTribesIntent extends TribesIntents {
  const LoadDiscoverTribesIntent();
}

final class SwitchTribesTabIntent extends TribesIntents {
  final TribesTab tab;
  const SwitchTribesTabIntent(this.tab);
}

final class SearchTribesIntent extends TribesIntents {
  final String query;
  const SearchTribesIntent(this.query);
}

final class LoadMoreTribesIntent extends TribesIntents {
  const LoadMoreTribesIntent();
}

final class ToggleFollowTribeIntent extends TribesIntents {
  final int groupId;
  const ToggleFollowTribeIntent(this.groupId);
}

final class LeaveTribeIntent extends TribesIntents {
  final int groupId;
  const LeaveTribeIntent(this.groupId);
}

final class ViewTribeIntent extends TribesIntents {
  final Group group;
  const ViewTribeIntent(this.group);
}

final class OpenCreateTribeIntent extends TribesIntents {
  const OpenCreateTribeIntent();
}
