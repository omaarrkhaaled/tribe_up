import 'package:json_annotation/json_annotation.dart';
part 'sign_up_response_entity.g.dart';

@JsonSerializable()
class SignUpResponseEntity {
  final String? accessToken;
  final String? refreshToken;

  const SignUpResponseEntity({this.accessToken, this.refreshToken});

  factory SignUpResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseEntityToJson(this);
}
