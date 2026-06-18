import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/domain/repository/feed_repository.dart';

@injectable
class GetPostByIdUseCase {
  final FeedRepository _repository;
  const GetPostByIdUseCase(this._repository);

  Future<BaseResponse<PostEntity>> call({required int postId}) async {
    return await _repository.getPostById(postId: postId);
  }
}
