sealed class ChatInboxIntents {
  const ChatInboxIntents();
}

class LoadChatInboxIntent extends ChatInboxIntents {
  const LoadChatInboxIntent();
}

class LoadMoreChatInboxIntent extends ChatInboxIntents {
  const LoadMoreChatInboxIntent();
}

class SearchChatInboxIntent extends ChatInboxIntents {
  final String query;
  const SearchChatInboxIntent({required this.query});
}
