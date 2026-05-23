sealed class CreatePostState {
  final bool isLoading;
  final String? errorMessage;

  const CreatePostState({this.isLoading = false, this.errorMessage});
}

class CreatePostInitial extends CreatePostState {
  const CreatePostInitial() : super();
}

class CreatePostLoading extends CreatePostState {
  const CreatePostLoading() : super(isLoading: true);
}

class CreatePostSuccess extends CreatePostState {
  const CreatePostSuccess() : super(isLoading: false);
}

class CreatePostError extends CreatePostState {
  const CreatePostError(String message)
    : super(isLoading: false, errorMessage: message);
}
