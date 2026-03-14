import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/domain/entities/add_and_edit_comment_response_entity.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_response_entity.dart';

abstract interface class CommentsRepository {
  Future<BaseResponse<CommentsResponseEntity>> getComments({
    required int postId,
    required int page,
    required int pageSize,
  });

  Future<BaseResponse<AddAndEditCommentResponseEntity>> addComment({
    required int postId,
    required String content,
    List<String>? taggedUserIds,
  });

  Future<BaseResponse<void>> deleteComment({required int commentId});

  Future<BaseResponse<AddAndEditCommentResponseEntity>> editComment({
    required int commentId,
    required String content,
    List<String>? taggedUserIds,
  });

  Future<BaseResponse<void>> commentToggleLike({required int commentId});
}
