import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/logout/domain/repository/logout_repository.dart';

@injectable
class LogoutUseCase {
  final LogoutRepository logoutRepository;

  LogoutUseCase(this.logoutRepository);

  Future<BaseResponse<void>> call() async {
    return logoutRepository.logout();
  }
}