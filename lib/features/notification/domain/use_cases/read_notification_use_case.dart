import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/domain/repository/notification_repository.dart';

@lazySingleton
class ReadNotificationUseCase {
  final NotificationRepository _repository;

  ReadNotificationUseCase(this._repository);

  Future<BaseResponse<void>> call({required int id}) {
    return _repository.readNotification(id: id);
  }
}
