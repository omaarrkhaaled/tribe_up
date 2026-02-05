import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/auth/logout/data/data_sources/logout_local_data_source.dart';
import 'package:tribe_up/features/auth/logout/data/data_sources/logout_remote_data_source.dart';
import 'package:tribe_up/features/auth/logout/domain/repository/logout_repository.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource logoutRemoteDataSource;
  final LogoutLocalDataSource logoutLocalDataSource;

  LogoutRepositoryImpl(this.logoutRemoteDataSource, this.logoutLocalDataSource);

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
}
