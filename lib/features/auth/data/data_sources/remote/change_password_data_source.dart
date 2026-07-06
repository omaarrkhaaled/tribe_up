import 'package:tribe_up/features/auth/data/models/change_password_request.dart';

abstract class ChangePasswordDataSource {
  Future<void> changePassword(ChangePasswordRequest request);
}
