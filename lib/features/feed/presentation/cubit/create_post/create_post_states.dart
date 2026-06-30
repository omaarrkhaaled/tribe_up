import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';

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
  final PostEntity post;
  const CreatePostSuccess(this.post) : super(isLoading: false);
}

class CreateStorySuccess extends CreatePostState {
  final StoryEntity story;
  const CreateStorySuccess(this.story) : super(isLoading: false);
}

class CreatePostError extends CreatePostState {
  const CreatePostError(String message)
    : super(isLoading: false, errorMessage: message);
}
