import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/data/models/response/notification_response.dart';

abstract interface class NotificationDataSource {
  Future<BaseResponse<NotificationResponse>> getNotifications({
    required int pageNumber,
    required int pageSize,
  });

  Future<BaseResponse<void>> readNotification({required int id});

  Future<BaseResponse<void>> readAllNotifications();
}
