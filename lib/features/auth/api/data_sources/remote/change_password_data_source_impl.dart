import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/api/api_client/change_password_api_client.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/change_password_data_source.dart';
import 'package:tribe_up/features/auth/data/models/change_password_request.dart';

@Injectable(as: ChangePasswordDataSource)
class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final ChangePasswordApiClient _apiClient;

  ChangePasswordDataSourceImpl(this._apiClient);
  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    return await _apiClient.changePassword(request);
  }
}
