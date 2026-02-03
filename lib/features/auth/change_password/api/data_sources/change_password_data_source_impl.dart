import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/change_password/api/api_client/change_password_api_client.dart';
import 'package:tribe_up/features/auth/change_password/data/data_sources/change_password_data_source.dart';
import 'package:tribe_up/features/auth/change_password/data/models/change_password_request.dart';

@Injectable(as: ChangePasswordDataSource)
class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final ChangePasswordApiClient _apiClient;

  ChangePasswordDataSourceImpl(this._apiClient);
  @override
  Future<void> changePassword(ChangePasswordRequest request) async{
    return await _apiClient.changePassword(request);
  }
}
