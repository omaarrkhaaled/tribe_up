import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/login/domain/repository/login_repositiry.dart';

@injectable
class RefreshTokenUseCase {
  final LoginRepositiry repository;

  RefreshTokenUseCase(this.repository);

  Future<BaseResponse<LoginResponseEntity>> call({
    required String refreshToken,
    required String deviceId,
  }) {
    return repository.refreshToken(
      refreshToken: refreshToken,
      deviceId: deviceId,
    );
  }
}
