import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/domain/repository/comments_repository.dart';

@lazySingleton
class LikeCommentUseCase {
  final CommentsRepository _commentsRepository;

  LikeCommentUseCase(this._commentsRepository);

  Future<BaseResponse<void>> call(int commentId) {
    return _commentsRepository.commentToggleLike(commentId: commentId);
  }
}
