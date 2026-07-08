import 'package:tribe_up/features/polls/data/models/poll_models.dart';

sealed class PollsUiIntents {
  const PollsUiIntents();
}

final class ShowErrorUiIntent extends PollsUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class ShowSuccessUiIntent extends PollsUiIntents {
  final String message;
  const ShowSuccessUiIntent(this.message);
}

final class PollCreatedUiIntent extends PollsUiIntents {
  final Poll poll;
  const PollCreatedUiIntent(this.poll);
}

final class PollUpdatedUiIntent extends PollsUiIntents {
  final Poll poll;
  const PollUpdatedUiIntent(this.poll);
}

final class PollDeletedUiIntent extends PollsUiIntents {
  const PollDeletedUiIntent();
}
