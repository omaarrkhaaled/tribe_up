import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';

abstract interface class NotificationRepository {
  Future<BaseResponse<NotificationResponseEntity>> getNotifications({
    required int pageNumber,
    required int pageSize,
  });

  Future<BaseResponse<void>> readNotification({required int id});
}
