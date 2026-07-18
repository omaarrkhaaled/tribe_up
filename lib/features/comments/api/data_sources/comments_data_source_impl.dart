import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/comments/api/api_client/comments_api_client.dart';
import 'package:tribe_up/features/comments/data/data_source/comments_data_source.dart';
import 'package:tribe_up/features/comments/data/models/request/edit_comment_request_model.dart';
import 'package:tribe_up/features/comments/data/models/response/add_and_edit_comment_response_model.dart';
import 'package:tribe_up/features/comments/data/models/response/comments_model.dart';

@LazySingleton(as: CommentsDataSource)
class CommentsDataSourceImpl implements CommentsDataSource {
  final CommentsApiClient _commentsApiClient;
  CommentsDataSourceImpl(this._commentsApiClient);
  @override
  Future<BaseResponse<CommentsResponseModel>> getComments({
    required int postId,
    required int page,
    required int pageSize,
  }) {
    return safeApiCall(
      () => _commentsApiClient.getComments(postId, page, pageSize),
    );
  }

  @override
  Future<BaseResponse<AddAndEditCommentResponseModel>> addComment({
    required int postId,
    required String content,
    required List<String>? taggedUserIds,
  }) {
    return safeApiCall(
      () => _commentsApiClient.addComment(postId, content, taggedUserIds),
    );
  }

  @override
  Future<BaseResponse<void>> deleteComment({required int commentId}) {
    return safeApiCall(() => _commentsApiClient.deleteComment(commentId));
  }

  @override
  Future<BaseResponse<AddAndEditCommentResponseModel>> editComment({
    required int commentId,
    required EditCommentRequestModel request,
  }) {
    return safeApiCall(
      () => _commentsApiClient.editComment(commentId, request),
    );
  }

  @override
  Future<BaseResponse<void>> commentToggleLike({required int commentId}) {
    return safeApiCall(() => _commentsApiClient.commentToggleLike(commentId));
  }
}
