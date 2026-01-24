import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';
part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String? accessToken;
  final String? refreshToken;

  const LoginResponseModel({this.accessToken, this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
