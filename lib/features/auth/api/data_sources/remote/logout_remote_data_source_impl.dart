import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/api/api_client/logout_api_client.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/logout_remote_data_source.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final LogoutApiClient logoutApiClient;

  LogoutRemoteDataSourceImpl(this.logoutApiClient);

  @override
  Future<void> logout() async {
    await logoutApiClient.logout();
  }
}
