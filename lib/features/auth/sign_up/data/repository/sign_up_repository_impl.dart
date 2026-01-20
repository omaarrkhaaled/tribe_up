import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/sign_up/data/data_sources/sign_up_local_data_source.dart';
import 'package:tribe_up/features/auth/sign_up/data/data_sources/sign_up_remote_data_source.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_response/sign_up_response_model.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_request/sign_up_request_model.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_response/sign_up_response_entity.dart';
import 'package:tribe_up/features/auth/sign_up/domain/repository/sign_up_repositiry.dart';

@Injectable(as: SignUpRepository)
class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource remoteDataSource;
  final SignUpLocalDataSource localDataSource;

  SignUpRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<BaseResponse<SignUpResponseEntity>> signUp(
    SignUpRequestEntity requestEntity,
  ) async {
    final response = await remoteDataSource.signUp(
      SignUpRequestModel.fromEntity(requestEntity),
    );
    switch (response) {
      case SuccessResponse<SignUpResponseModel>():
        final localResponse = await localDataSource.saveTokens(
          refreshToken: response.data.refreshToken!,
          token: response.data.accessToken!,
        );
        switch (localResponse) {
          case SuccessResponse<void>():
            return SuccessResponse<SignUpResponseEntity>(
              data: response.data.toEntity(),
            );
          case ErrorResponse<void>():
            return ErrorResponse<SignUpResponseEntity>(
              error: localResponse.error,
            );
        }

      case ErrorResponse<SignUpResponseModel>():
        return ErrorResponse<SignUpResponseEntity>(error: response.error);
    }
  }
}
