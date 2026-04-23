import 'package:json_annotation/json_annotation.dart';
part 'update_name_request.g.dart';

@JsonSerializable()
class UpdateNameRequest {
  @JsonKey(name: 'firstName')
  String firstName;

  @JsonKey(name: 'lastName')
  String lastName;

  UpdateNameRequest({required this.firstName, required this.lastName});

  factory UpdateNameRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNameRequestToJson(this);
}
