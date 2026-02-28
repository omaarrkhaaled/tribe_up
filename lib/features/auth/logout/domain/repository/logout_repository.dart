import 'package:tribe_up/config/base_response/base_response.dart';

abstract class LogoutRepository {
  Future<BaseResponse<void>> logout();
}
