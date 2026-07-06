import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/domain/repositories/auth_repository.dart';

@injectable
class RefreshTokenUseCase {
  final AuthRepository repository;

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
