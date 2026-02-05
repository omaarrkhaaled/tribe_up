import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/auth/forget_password/data/data_sources/forget_password_data_source.dart';
import 'package:tribe_up/features/auth/forget_password/data/models/forget_password_request.dart';
import 'package:tribe_up/features/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/forget_password/domain/repositories/foreget_password_repositoy.dart';

@Injectable(as: ForgetPasswordRepository)
class ForegetPasswordRepositoryImpl implements ForgetPasswordRepository {
  final ForgetPasswordDataSource _forgetPasswordDataSource;

  const ForegetPasswordRepositoryImpl(this._forgetPasswordDataSource);
  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequestEntity request,
  ) {
    return safeApiCall<void>(() async {
      await _forgetPasswordDataSource.forgetPassword(
        ForgetPasswordRequest.fromEntity(request),
      );
    });
  }
}
