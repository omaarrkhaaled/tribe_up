import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

sealed class TribesUiIntents {
  const TribesUiIntents();
}

final class ShowErrorUiIntent extends TribesUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class NavigateToTribeProfileUiIntent extends TribesUiIntents {
  final Group group;
  const NavigateToTribeProfileUiIntent(this.group);
}

final class ShowCreateTribeSheetUiIntent extends TribesUiIntents {
  const ShowCreateTribeSheetUiIntent();
}
