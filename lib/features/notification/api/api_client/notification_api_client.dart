import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/notification/data/models/response/notification_response.dart';

part 'notification_api_client.g.dart';

@LazySingleton()
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationApiClient {
  @factoryMethod
  factory NotificationApiClient(Dio dio) = _NotificationApiClient;

  @GET(ApiConstants.notificationsEndPoint)
  Future<NotificationResponse> getNotifications(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );

  @PUT(ApiConstants.notificationReadEndPoint)
  Future<void> readNotification(@Path('id') int id);
}
