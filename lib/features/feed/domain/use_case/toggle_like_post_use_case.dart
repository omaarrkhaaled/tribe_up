import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@lazySingleton
class ToggleLikePostUseCase {
  final FeedRepository _repository;

  const ToggleLikePostUseCase(this._repository);

  Future<BaseResponse<({bool isLiked, int likesCount})>> call({
    required int postId,
  }) {
    return _repository.toggleLikePost(postId: postId);
  }
}
