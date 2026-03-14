import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/data/models/request/edit_comment_request_model.dart';
import 'package:tribe_up/features/comments/data/models/response/add_and_edit_comment_response_model.dart';
import 'package:tribe_up/features/comments/data/models/response/comments_model.dart';

abstract interface class CommentsDataSource {
  Future<BaseResponse<CommentsResponseModel>> getComments({
    required int postId,
    required int page,
    required int pageSize,
  });

  Future<BaseResponse<AddAndEditCommentResponseModel>> addComment({
    required int postId,
    required String content,
    required List<String>? taggedUserIds,
  });

  Future<BaseResponse<void>> deleteComment({required int commentId});

  Future<BaseResponse<AddAndEditCommentResponseModel>> editComment({
    required int commentId,
    required EditCommentRequestModel request,
  });

  Future<BaseResponse<void>> commentToggleLike({required int commentId});
}
