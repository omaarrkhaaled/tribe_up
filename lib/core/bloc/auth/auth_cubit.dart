import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/device_id_manager.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/auth/domain/use_cases/refresh_token_use_case.dart';
import 'package:tribe_up/core/services/signalr/notification_signalr_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final LoginLocalDataSource _localDataSource;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final DeviceIdManager _deviceIdManager;
  final NotificationSignalRService _notificationSignalRService;

  AuthCubit(
    this._localDataSource,
    this._refreshTokenUseCase,
    this._deviceIdManager,
    this._notificationSignalRService,
  ) : super(const AuthState.unknown());

  Future<void> checkAuthStatus() async {
    final String? accessToken = await _localDataSource.getAccessToken();
    if (accessToken == null) {
      _emitUnauthenticated();
      return;
    }
    if (!JwtDecoder.isExpired(accessToken)) {
      _emitAuthenticated();
      return;
    }
    final String? refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null) {
      _emitUnauthenticated();
      return;
    }
    final deviceId = _deviceIdManager.deviceId;
    final result = await _refreshTokenUseCase.call(
      refreshToken: refreshToken,
      deviceId: deviceId,
    );
    switch (result) {
      case SuccessResponse():
        _emitAuthenticated();
        break;
      case ErrorResponse():
        _emitUnauthenticated();
        break;
    }
  }

  void _emitAuthenticated() {
    emit(const AuthState.authenticated());
    _notificationSignalRService.connect();
  }

  void _emitUnauthenticated() {
    emit(const AuthState.unauthenticated());
    _notificationSignalRService.disconnect();
  }

  void loggedIn() => _emitAuthenticated();

  void loggedOut() async {
    await _localDataSource.clearTokens();
    await _localDataSource.clearUserSummary();
    _emitUnauthenticated();
  }
}
