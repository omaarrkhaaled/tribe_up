sealed class ChatInboxUiIntents {}

class ChatInboxErrorUiIntent extends ChatInboxUiIntents {
  final String message;
  ChatInboxErrorUiIntent({required this.message});
}
