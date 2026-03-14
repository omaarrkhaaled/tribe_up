import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_response_entity.dart';
import 'package:tribe_up/features/comments/domain/repository/comments_repository.dart';

@lazySingleton
class GetCommentsUseCase {
  final CommentsRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<BaseResponse<CommentsResponseEntity>> call({
    required int postId,
    required int page,
    required int pageSize,
  }) {
    return _repository.getComments(
      postId: postId,
      page: page,
      pageSize: pageSize,
    );
  }
}
