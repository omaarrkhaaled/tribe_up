import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/logout/data/data_sources/logout_local_data_source.dart';

@Injectable(as: LogoutLocalDataSource)
class LogoutLocalDataSourceImpl implements LogoutLocalDataSource {
  final Box<String> _box;

  LogoutLocalDataSourceImpl(this._box);

  @override
  Future<BaseResponse<void>> clearTokens() async {
    await _box.delete(CacheConstants.tokenKey);
    await _box.delete(CacheConstants.refreshTokenKey);
    return SuccessResponse<void>(data: null);
  }
}
