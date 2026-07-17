import 'package:json_annotation/json_annotation.dart';
part 'update_phone_request.g.dart';

@JsonSerializable()
class UpdatePhoneRequest {
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  UpdatePhoneRequest({this.phoneNumber});

  factory UpdatePhoneRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePhoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePhoneRequestToJson(this);
}
