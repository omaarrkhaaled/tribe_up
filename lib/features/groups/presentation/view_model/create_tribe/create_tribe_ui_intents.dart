import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

sealed class CreateTribeUiIntents {
  const CreateTribeUiIntents();
}

final class ShowErrorUiIntent extends CreateTribeUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class TribeCreatedUiIntent extends CreateTribeUiIntents {
  final Group tribe;
  const TribeCreatedUiIntent(this.tribe);
}
