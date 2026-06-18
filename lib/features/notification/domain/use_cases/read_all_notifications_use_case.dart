import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/domain/repository/notification_repository.dart';

@lazySingleton
class ReadAllNotificationsUseCase {
  final NotificationRepository _repository;

  ReadAllNotificationsUseCase(this._repository);

  Future<BaseResponse<void>> call() {
    return _repository.readAllNotifications();
  }
}
