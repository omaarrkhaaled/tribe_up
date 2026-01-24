import 'package:json_annotation/json_annotation.dart';

part 'login_request_entity.g.dart';

@JsonSerializable()
class LoginRequestEntity {
  final String? email;
  final String? password;

  const LoginRequestEntity({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestEntityToJson(this);

  factory LoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestEntityFromJson(json);
}
