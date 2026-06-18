import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';

class PostDetailStates extends BaseState<PostEntity?> {
  final bool isTogglingLike;
  final bool isDeleting;
  final bool isEditing;

  const PostDetailStates({
    super.isLoading = false,
    super.data,
    super.errorMessage,
    this.isTogglingLike = false,
    this.isDeleting = false,
    this.isEditing = false,
  });

  PostDetailStates copyWith({
    bool? isLoading,
    PostEntity? data,
    String? errorMessage,
    bool clearError = false,
    bool? isTogglingLike,
    bool? isDeleting,
    bool? isEditing,
  }) {
    return PostDetailStates(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isTogglingLike: isTogglingLike ?? this.isTogglingLike,
      isDeleting: isDeleting ?? this.isDeleting,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    data,
    errorMessage,
    isTogglingLike,
    isDeleting,
    isEditing,
  ];
}
