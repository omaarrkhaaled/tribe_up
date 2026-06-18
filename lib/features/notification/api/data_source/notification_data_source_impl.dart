import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/notification/api/api_client/notification_api_client.dart';
import 'package:tribe_up/features/notification/data/data_sources/notification_data_source.dart';
import 'package:tribe_up/features/notification/data/models/response/notification_response.dart';

@LazySingleton(as: NotificationDataSource)
class NotificationDataSourceImpl implements NotificationDataSource {
  final NotificationApiClient _notificationApiClient;

  NotificationDataSourceImpl(this._notificationApiClient);

  @override
  Future<BaseResponse<NotificationResponse>> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) {
    return safeApiCall(
      () => _notificationApiClient.getNotifications(pageNumber, pageSize),
    );
  }

  @override
  Future<BaseResponse<void>> readNotification({required int id}) {
    return safeApiCall(() => _notificationApiClient.readNotification(id));
  }

  @override
  Future<BaseResponse<void>> readAllNotifications() {
    return safeApiCall(() => _notificationApiClient.readAllNotifications());
  }
}
