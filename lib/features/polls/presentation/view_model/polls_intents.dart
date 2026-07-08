import 'package:tribe_up/features/polls/data/models/poll_models.dart';

sealed class PollsIntents {
  const PollsIntents();
}

final class LoadPollsIntent extends PollsIntents {
  final int groupId;
  final bool isRefresh;
  const LoadPollsIntent({required this.groupId, this.isRefresh = false});
}

final class LoadMorePollsIntent extends PollsIntents {
  final int groupId;
  const LoadMorePollsIntent({required this.groupId});
}

final class CreatePollIntent extends PollsIntents {
  final int groupId;
  final CreatePollRequest request;
  const CreatePollIntent({required this.groupId, required this.request});
}

final class UpdatePollIntent extends PollsIntents {
  final int pollId;
  final EditPollRequest request;
  const UpdatePollIntent({required this.pollId, required this.request});
}

final class DeletePollIntent extends PollsIntents {
  final int pollId;
  const DeletePollIntent({required this.pollId});
}

final class ToggleVoteIntent extends PollsIntents {
  final int pollId;
  final int optionId;
  const ToggleVoteIntent({required this.pollId, required this.optionId});
}

final class RefreshPollByIdIntent extends PollsIntents {
  final int pollId;
  const RefreshPollByIdIntent({required this.pollId});
}
