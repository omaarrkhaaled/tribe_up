import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_entity.g.dart';

@JsonSerializable()
class SignUpRequestEntity {
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? password;
  final String? confirmPassword;

  const SignUpRequestEntity({
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$SignUpRequestEntityToJson(this);

  factory SignUpRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestEntityFromJson(json);
}
