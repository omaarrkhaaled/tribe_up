import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/auth/forget_password/api/api_client/forget_password_api_client.dart';
import 'package:tribe_up/features/auth/forget_password/data/data_sources/forget_password_data_source.dart';
import 'package:tribe_up/features/auth/forget_password/data/models/forget_password_request.dart';

@Injectable(as: ForgetPasswordDataSource)
class ForgetPasswordDataSourceImpl implements ForgetPasswordDataSource {
  final ForgetPasswordApiClient _forgetPasswordApiClient;

  ForgetPasswordDataSourceImpl(this._forgetPasswordApiClient);

  @override
  Future<void> forgetPassword(ForgetPasswordRequest request) async {
    await _forgetPasswordApiClient.forgetPassword(request);
  }
}
