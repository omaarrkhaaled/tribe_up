sealed class InviteUiIntents {
  const InviteUiIntents();
}

final class ShowErrorUiIntent extends InviteUiIntents {
  final String message;
  const ShowErrorUiIntent(this.message);
}

final class ShowSuccessUiIntent extends InviteUiIntents {
  final String message;
  const ShowSuccessUiIntent(this.message);
}

final class CopyLinkUiIntent extends InviteUiIntents {
  final String url;
  const CopyLinkUiIntent(this.url);
}
