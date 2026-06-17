import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_message_model.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_messages_response.dart';

part 'group_chat_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GroupChatApiClient {
  @factoryMethod
  factory GroupChatApiClient(Dio dio) = _GroupChatApiClient;

  @GET(ApiConstants.groupChatGetMessagesEndPoint)
  Future<ChatMessagesResponse> getMessages(
    @Query('groupId') int groupId,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );

  @POST(ApiConstants.groupChatSendMessageEndPoint)
  Future<ChatMessageModel> sendMessage(
    @Path('groupId') int groupId,
    @Body() Map<String, dynamic> body,
  );

  @PUT(ApiConstants.groupChatEditMessageEndPoint)
  Future<ChatMessageModel> editMessage(
    @Path('messageId') int messageId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(ApiConstants.groupChatDeleteMessageEndPoint)
  Future<void> deleteMessage(@Path('messageId') int messageId);
}
