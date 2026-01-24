import 'package:json_annotation/json_annotation.dart';
part 'login_response_entity.g.dart';

@JsonSerializable()
class LoginResponseEntity {
   final String? accessToken;
  final String? refreshToken;

  const LoginResponseEntity({this.accessToken, this.refreshToken});
  
  factory LoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseEntityToJson(this);
}