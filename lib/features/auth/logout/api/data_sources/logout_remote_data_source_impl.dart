import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/logout/api/api_client/logout_api_client.dart';
import 'package:tribe_up/features/auth/logout/data/data_sources/logout_remote_data_source.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final LogoutApiClient logoutApiClient;

  LogoutRemoteDataSourceImpl(this.logoutApiClient);

  @override
  Future<void> logout() async {
    await logoutApiClient.logout();
  }
}
