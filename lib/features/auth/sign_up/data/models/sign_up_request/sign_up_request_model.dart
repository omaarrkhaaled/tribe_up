import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_request/sign_up_request_entity.dart';
part 'sign_up_request_model.g.dart';

@JsonSerializable()
class SignUpRequestModel {
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? password;
  final String? confirmPassword;

  const SignUpRequestModel({
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password,
    this.confirmPassword,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestModelToJson(this);

  SignUpRequestEntity toEntity() {
    return SignUpRequestEntity(
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  factory SignUpRequestModel.fromEntity(SignUpRequestEntity entity) {
    return SignUpRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      userName: entity.userName,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }
}
