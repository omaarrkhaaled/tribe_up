import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginRequestEntity {
  final String? email;
  final String? password;

  const LoginRequestEntity({this.email, this.password});
}
