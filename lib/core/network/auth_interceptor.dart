import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/core/network/device_id_manager.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/refresh_token_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_response/login_response_model.dart';

class AuthInterceptor extends Interceptor {
  final Box<String> tokenBox;
  final DeviceIdManager deviceIdManager;
  final String baseUrl;

  AuthInterceptor({
    required this.tokenBox,
    required this.deviceIdManager,
    required this.baseUrl,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenBox.get(CacheConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = tokenBox.get(CacheConstants.refreshTokenKey);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Use a fresh Dio instance to avoid circular dependency
          final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
          final response = await refreshDio.post(
            ApiConstants.refreshEndPoint,
            data: RefreshTokenRequestModel(
              refreshToken: refreshToken,
              deviceId: deviceIdManager.deviceId,
            ).toJson(),
          );

          if (response.statusCode == 200) {
            final loginResponse = LoginResponseModel.fromJson(response.data);
            if (loginResponse.accessToken != null &&
                loginResponse.refreshToken != null) {
              await tokenBox.put(
                CacheConstants.tokenKey,
                loginResponse.accessToken!,
              );
              await tokenBox.put(
                CacheConstants.refreshTokenKey,
                loginResponse.refreshToken!,
              );

              // Retry the original request
              final options = err.requestOptions;
              options.headers['Authorization'] =
                  'Bearer ${loginResponse.accessToken}';

              // Ensure we use the same method and headers for retry
              final retryResponse = await refreshDio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
              );

              return handler.resolve(retryResponse);
            }
          }
        } catch (e) {
          // If refresh fails, clear tokens
          await tokenBox.delete(CacheConstants.tokenKey);
          await tokenBox.delete(CacheConstants.refreshTokenKey);
        }
      }
    }
    return handler.next(err);
  }
}
