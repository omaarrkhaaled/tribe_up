import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/api/api_client/forget_password_api_client.dart';
import 'package:tribe_up/features/auth/data/data_sources/remote/forget_password_data_source.dart';
import 'package:tribe_up/features/auth/data/models/forget_password_request.dart';

@Injectable(as: ForgetPasswordDataSource)
class ForgetPasswordDataSourceImpl implements ForgetPasswordDataSource {
  final ForgetPasswordApiClient _forgetPasswordApiClient;

  ForgetPasswordDataSourceImpl(this._forgetPasswordApiClient);

  @override
  Future<void> forgetPassword(ForgetPasswordRequest request) async {
    await _forgetPasswordApiClient.forgetPassword(request);
  }
}
