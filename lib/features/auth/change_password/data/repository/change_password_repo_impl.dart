import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/auth/change_password/data/data_sources/change_password_data_source.dart';
import 'package:tribe_up/features/auth/change_password/data/models/change_password_request.dart';
import 'package:tribe_up/features/auth/change_password/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/change_password/domain/repository/change_password_repo.dart';

@Injectable(as: ChangePasswordRepo)
class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ChangePasswordDataSource _dataSource;

  ChangePasswordRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<void>> changePassword(
    ChangePasswordRequestEntity request,
  ) {
    return safeApiCall<void>(() async {
      return await _dataSource.changePassword(
        ChangePasswordRequest.fromEntity(request),
      );
    });
  }
}
