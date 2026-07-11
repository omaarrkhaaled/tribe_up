import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/data/models/login_response/user_summary_model.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/login_response_entity.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'accessToken')
  final String? accessToken;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;
  @JsonKey(name: 'userSummary')
  final UserSummaryModel? userSummary;

  const LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.userSummary,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userSummary: userSummary?.toEntity(),
    );
  }
}
