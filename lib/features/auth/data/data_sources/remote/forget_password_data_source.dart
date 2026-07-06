import 'package:tribe_up/features/auth/data/models/forget_password_request.dart';

abstract class ForgetPasswordDataSource {
  Future<void> forgetPassword(ForgetPasswordRequest request);
}
