import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/domain/repository/comments_repository.dart';

@lazySingleton
class DeleteCommentUseCase {
  final CommentsRepository _repository;

  DeleteCommentUseCase(this._repository);

  Future<BaseResponse<void>> call({required int commentId}) {
    return _repository.deleteComment(commentId: commentId);
  }
}
