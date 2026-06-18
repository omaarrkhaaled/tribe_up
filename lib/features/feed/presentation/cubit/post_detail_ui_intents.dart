sealed class PostDetailUiIntents {
  const PostDetailUiIntents();
}

class PostDetailShowErrorIntent extends PostDetailUiIntents {
  final String error;
  const PostDetailShowErrorIntent(this.error);
}

class PostDetailDeleteSuccessIntent extends PostDetailUiIntents {
  const PostDetailDeleteSuccessIntent();
}

class PostDetailEditSuccessIntent extends PostDetailUiIntents {
  const PostDetailEditSuccessIntent();
}
