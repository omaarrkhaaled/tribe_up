import 'package:json_annotation/json_annotation.dart';

part 'update_group_request.g.dart';

@JsonSerializable()
class UpdateGroupRequest {
  @JsonKey(name: 'groupName')
  final String? groupName;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'accessibility')
  final int? accessibility;

  UpdateGroupRequest({this.groupName, this.description, this.accessibility});

  factory UpdateGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateGroupRequestToJson(this);
}
