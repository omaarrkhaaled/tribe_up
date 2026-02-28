import 'package:tribe_up/features/auth/change_password/data/models/change_password_request.dart';

abstract class ChangePasswordDataSource {
  Future<void> changePassword(ChangePasswordRequest request);
}
