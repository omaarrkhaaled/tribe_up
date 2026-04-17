import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';
import 'package:tribe_up/features/notification/domain/repository/notification_repository.dart';

@lazySingleton
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<BaseResponse<NotificationResponseEntity>> call({
    required int pageNumber,
    required int pageSize,
  }) {
    return _repository.getNotifications(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
