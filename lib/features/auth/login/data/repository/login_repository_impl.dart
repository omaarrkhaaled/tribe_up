import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/login/domain/repository/login_repositiry.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_remote_data_source.dart';
import 'package:tribe_up/features/auth/login/data/models/login_response/login_response_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/login_request_model.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';

@Injectable(as: LoginRepositiry)
class LoginRepositoryImpl implements LoginRepositiry {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;

  LoginRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<BaseResponse<LoginResponseEntity>> login(
    LoginRequestEntity requestEntity,
  ) async {
    final response = await remoteDataSource.login(
      LoginRequestModel.fromEntity(requestEntity),
    );
    switch (response) {
      case SuccessResponse<LoginResponseModel>():
        final localResponse = await localDataSource.saveTokens(
          refreshToken: response.data.refreshToken!,
          token: response.data.accessToken!,
        );
        switch (localResponse) {
          case SuccessResponse<void>():
            return SuccessResponse<LoginResponseEntity>(
              data: response.data.toEntity(),
            );
          case ErrorResponse<void>():
            return ErrorResponse<LoginResponseEntity>(
              error: localResponse.error,
            );
        }

      case ErrorResponse<LoginResponseModel>():
        return ErrorResponse<LoginResponseEntity>(error: response.error);
    }
  }
}
