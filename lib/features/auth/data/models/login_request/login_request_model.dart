import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/domain/entities/login_request/login_request_entity.dart';
part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String? email;
  final String? password;

  const LoginRequestModel({this.email, this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  LoginRequestEntity toEntity() {
    return LoginRequestEntity(email: email, password: password);
  }

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(email: entity.email, password: entity.password);
  }
}
