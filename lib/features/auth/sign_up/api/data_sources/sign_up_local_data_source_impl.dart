import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/sign_up/data/data_sources/sign_up_local_data_source.dart';

@Injectable(as: SignUpLocalDataSource)
class SignUpLocalDataSourceImpl implements SignUpLocalDataSource {
  final Box<String> _box;

  SignUpLocalDataSourceImpl(this._box);

  @override
  Future<BaseResponse<void>> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _box.put(CacheConstants.tokenKey, token);
    await _box.put(CacheConstants.refreshTokenKey, refreshToken);
    return SuccessResponse<void>(data: null);
  }
}
