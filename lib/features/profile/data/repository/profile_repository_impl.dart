import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data_source/profile_data_source.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
import 'package:tribe_up/features/profile/domain/repository/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<ProfileEntity>> getUserProfile(String userName) async {
    final response = await _dataSource.getUserProfile(userName);
    switch (response) {
      case SuccessResponse(data: final data):
        return SuccessResponse(data: data.toEntity());
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }
}
