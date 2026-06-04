import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@lazySingleton
class DeletePostUseCase {
  final FeedRepository _repository;

  const DeletePostUseCase(this._repository);

  Future<BaseResponse<bool>> call({required int postId}) {
    return _repository.deletePost(postId: postId);
  }
}
