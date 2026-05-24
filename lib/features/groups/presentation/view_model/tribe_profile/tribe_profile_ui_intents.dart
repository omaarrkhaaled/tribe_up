import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

sealed class TribeProfileUiIntents {
  const TribeProfileUiIntents();
}

final class ShowErrorUiIntent extends TribeProfileUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class ShowSuccessUiIntent extends TribeProfileUiIntents {
  final String message;
  const ShowSuccessUiIntent(this.message);
}

final class NavigateBackUiIntent extends TribeProfileUiIntents {
  final bool didChangeTribe;
  const NavigateBackUiIntent({this.didChangeTribe = false});
}

final class OpenSettingsSheetUiIntent extends TribeProfileUiIntents {
  final Group tribe;
  const OpenSettingsSheetUiIntent(this.tribe);
}

final class OpenInviteSheetUiIntent extends TribeProfileUiIntents {
  const OpenInviteSheetUiIntent();
}
