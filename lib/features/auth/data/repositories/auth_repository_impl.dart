import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/auth/domain/repositories/auth_repository.dart';

import 'package:tribe_up/features/auth/data/data_sources/remote/change_password_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/forget_password_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/login_remote_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/logout_remote_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/logout_local_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/sign_up_remote_data_source.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/sign_up_local_data_source.dart';

import 'package:tribe_up/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_response/sign_up_response_entity.dart';

import 'package:tribe_up/features/auth/data/models/change_password_request.dart';
import 'package:tribe_up/features/auth/data/models/forget_password_request.dart';
import 'package:tribe_up/features/auth/data/models/login_request/login_request_model.dart';
import 'package:tribe_up/features/auth/data/models/login_request/refresh_token_request_model.dart';
import 'package:tribe_up/features/auth/data/models/login_response/login_response_model.dart';
import 'package:tribe_up/features/auth/data/models/sign_up_request/sign_up_request_model.dart';
import 'package:tribe_up/features/auth/data/models/sign_up_response/sign_up_response_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ChangePasswordDataSource changePasswordDataSource;
  final ForgetPasswordDataSource forgetPasswordDataSource;
  final LoginRemoteDataSource loginRemoteDataSource;
  final LoginLocalDataSource loginLocalDataSource;
  final LogoutRemoteDataSource logoutRemoteDataSource;
  final LogoutLocalDataSource logoutLocalDataSource;
  final SignUpRemoteDataSource signUpRemoteDataSource;
  final SignUpLocalDataSource signUpLocalDataSource;

  AuthRepositoryImpl(
    this.changePasswordDataSource,
    this.forgetPasswordDataSource,
    this.loginRemoteDataSource,
    this.loginLocalDataSource,
    this.logoutRemoteDataSource,
    this.logoutLocalDataSource,
    this.signUpRemoteDataSource,
    this.signUpLocalDataSource,
  );

  @override
  Future<BaseResponse<void>> changePassword(
    ChangePasswordRequestEntity request,
  ) {
    return safeApiCall<void>(() async {
      return await changePasswordDataSource.changePassword(
        ChangePasswordRequest.fromEntity(request),
      );
    });
  }

  @override
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequestEntity request,
  ) {
    return safeApiCall<void>(() async {
      await forgetPasswordDataSource.forgetPassword(
        ForgetPasswordRequest.fromEntity(request),
      );
    });
  }

  @override
  Future<BaseResponse<LoginResponseEntity>> login(
    LoginRequestEntity requestEntity,
  ) async {
    final response = await loginRemoteDataSource.login(
      LoginRequestModel.fromEntity(requestEntity),
    );
    switch (response) {
      case SuccessResponse<LoginResponseModel>():
        final localResponse = await loginLocalDataSource.saveTokens(
          refreshToken: response.data.refreshToken!,
          token: response.data.accessToken!,
        );

        if (response.data.userSummary != null) {
          await loginLocalDataSource.saveUserSummary(
            userSummary: response.data.userSummary!,
          );
        }

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

  @override
  Future<BaseResponse<LoginResponseEntity>> refreshToken({
    required String refreshToken,
    required String deviceId,
  }) async {
    final response = await loginRemoteDataSource.refreshToken(
      RefreshTokenRequestModel(refreshToken: refreshToken, deviceId: deviceId),
    );
    switch (response) {
      case SuccessResponse<LoginResponseModel>():
        final localResponse = await loginLocalDataSource.saveTokens(
          refreshToken: response.data.refreshToken!,
          token: response.data.accessToken!,
        );

        if (response.data.userSummary != null) {
          await loginLocalDataSource.saveUserSummary(
            userSummary: response.data.userSummary!,
          );
        }

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

  @override
  Future<BaseResponse<void>> logout() async {
    final response = await safeApiCall<void>(() {
      return logoutRemoteDataSource.logout();
    });

    if (response is SuccessResponse) {
      await logoutLocalDataSource.clearTokens();
    }
    return response;
  }

  @override
  Future<BaseResponse<SignUpResponseEntity>> signUp(
    SignUpRequestEntity requestEntity,
  ) async {
    final response = await signUpRemoteDataSource.signUp(
      SignUpRequestModel.fromEntity(requestEntity),
    );
    switch (response) {
      case SuccessResponse<SignUpResponseModel>():
        final localResponse = await signUpLocalDataSource.saveTokens(
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
