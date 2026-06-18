import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/data/data_sources/notification_data_source.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';
import 'package:tribe_up/features/notification/domain/repository/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _notificationDataSource;

  NotificationRepositoryImpl(this._notificationDataSource);

  @override
  Future<BaseResponse<NotificationResponseEntity>> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _notificationDataSource.getNotifications(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<NotificationResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorResponse():
        return ErrorResponse<NotificationResponseEntity>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<void>> readNotification({required int id}) async {
    final response = await _notificationDataSource.readNotification(id: id);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<void>(data: null);
      case ErrorResponse():
        return ErrorResponse<void>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<void>> readAllNotifications() async {
    final response = await _notificationDataSource.readAllNotifications();
    switch (response) {
      case SuccessResponse():
        return SuccessResponse<void>(data: null);
      case ErrorResponse():
        return ErrorResponse<void>(error: response.error);
    }
  }
}
