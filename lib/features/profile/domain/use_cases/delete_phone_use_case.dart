import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class DeletePhoneUseCase {
  final EditProfileRepository repositoriy;

  DeletePhoneUseCase(this.repositoriy);
  Future<BaseResponse<void>> call() async {
    return await repositoriy.deletePhone();
  }
}
