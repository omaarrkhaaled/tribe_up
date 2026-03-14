import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/comments/data/models/request/edit_comment_request_model.dart';
import 'package:tribe_up/features/comments/data/models/response/add_and_edit_comment_response_model.dart';
import 'package:tribe_up/features/comments/data/models/response/comments_model.dart';

part 'comments_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class CommentsApiClient {
  @factoryMethod
  factory CommentsApiClient(Dio dio) = _CommentsApiClient;

  @GET(ApiConstants.commentsEndPoint)
  Future<CommentsResponseModel> getComments(
    @Path('postId') int postId,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );

  @POST(ApiConstants.addCommentEndPoint)
  @MultiPart()
  Future<AddAndEditCommentResponseModel> addComment(
    @Path('postId') int postId,
    @Part(name: 'Content') String content,
    @Part(name: 'TaggedUserIds') List<String>? taggedUserIds,
  );

  @DELETE(ApiConstants.deleteCommentEndPoint)
  Future<void> deleteComment(@Path('commentId') int commentId);

  @PUT(ApiConstants.editCommentEndPoint)
  Future<AddAndEditCommentResponseModel> editComment(
    @Path('commentId') int commentId,
    @Body() EditCommentRequestModel request,
  );

  @POST(ApiConstants.commentToggleLikeEndPoint)
  Future<void> commentToggleLike(@Path('commentId') int commentId);
}
