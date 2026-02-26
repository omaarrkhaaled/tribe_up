import 'package:tribe_up/features/auth/forget_password/data/models/forget_password_request.dart';

abstract class ForgetPasswordDataSource {
  Future<void> forgetPassword(ForgetPasswordRequest request);
}
