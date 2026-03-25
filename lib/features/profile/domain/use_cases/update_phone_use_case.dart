import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class UpdatePhoneUseCase {
  final ProfileRepositoriy repositoriy;

  UpdatePhoneUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(String? phone) async {
    return await repositoriy.updatePhone(phone);
  }
}
