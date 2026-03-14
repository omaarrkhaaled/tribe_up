import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/comments/data/data_source/comments_data_source.dart';
import 'package:tribe_up/features/comments/data/models/request/edit_comment_request_model.dart';
import 'package:tribe_up/features/comments/domain/entities/add_and_edit_comment_response_entity.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_response_entity.dart';
import 'package:tribe_up/features/comments/domain/repository/comments_repository.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsDataSource _commentsDataSource;

  CommentsRepositoryImpl(this._commentsDataSource);

  @override
  Future<BaseResponse<CommentsResponseEntity>> getComments({
    required int postId,
    required int page,
    required int pageSize,
  }) async {
    final response = await _commentsDataSource.getComments(
      postId: postId,
      page: page,
      pageSize: pageSize,
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<CommentsResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorResponse():
        return ErrorResponse<CommentsResponseEntity>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<AddAndEditCommentResponseEntity>> addComment({
    required int postId,
    required String content,
    List<String>? taggedUserIds,
  }) async {
    final response = await _commentsDataSource.addComment(
      postId: postId,
      content: content,
      taggedUserIds: taggedUserIds,
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<AddAndEditCommentResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorResponse():
        return ErrorResponse<AddAndEditCommentResponseEntity>(
          error: response.error,
        );
    }
  }

  @override
  Future<BaseResponse<void>> deleteComment({required int commentId}) async {
    final response = await _commentsDataSource.deleteComment(
      commentId: commentId,
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<void>(data: null);
      case ErrorResponse():
        return ErrorResponse<void>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<AddAndEditCommentResponseEntity>> editComment({
    required int commentId,
    required String content,
    List<String>? taggedUserIds,
  }) async {
    final response = await _commentsDataSource.editComment(
      commentId: commentId,
      request: EditCommentRequestModel(
        content: content,
        taggedUserIds: taggedUserIds,
      ),
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<AddAndEditCommentResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorResponse():
        return ErrorResponse<AddAndEditCommentResponseEntity>(
          error: response.error,
        );
    }
  }

  @override
  Future<BaseResponse<void>> commentToggleLike({required int commentId}) async {
    final response = await _commentsDataSource.commentToggleLike(
      commentId: commentId,
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<void>(data: null);
      case ErrorResponse():
        return ErrorResponse<void>(error: response.error);
    }
  }
}
