import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';

@Injectable(as: LoginLocalDataSource)
class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final Box<String> _box;

  LoginLocalDataSourceImpl(this._box);

  @override
  Future<BaseResponse<void>> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _box.put(CacheConstants.tokenKey, token);
    await _box.put(CacheConstants.refreshTokenKey, refreshToken);
    return SuccessResponse<void>(data: null);
  }

  @override
  Future<String?> getAccessToken() async {
    return _box.get(CacheConstants.tokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _box.get(CacheConstants.refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _box.delete(CacheConstants.tokenKey);
    await _box.delete(CacheConstants.refreshTokenKey);
  }
}
