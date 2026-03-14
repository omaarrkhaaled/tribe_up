import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/domain/entities/add_and_edit_comment_response_entity.dart';
import 'package:tribe_up/features/comments/domain/repository/comments_repository.dart';

@lazySingleton
class AddCommentUseCase {
  final CommentsRepository _repository;

  AddCommentUseCase(this._repository);

  Future<BaseResponse<AddAndEditCommentResponseEntity>> call({
    required int postId,
    required String content,
    List<String>? taggedUserIds,
  }) {
    return _repository.addComment(
      postId: postId,
      content: content,
      taggedUserIds: taggedUserIds,
    );
  }
}
