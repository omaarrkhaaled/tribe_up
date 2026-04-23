import 'package:json_annotation/json_annotation.dart';
part 'update_bio_request.g.dart';

@JsonSerializable()
class UpdateBioRequest {
  @JsonKey(name: 'bio')
  final String bio;

  UpdateBioRequest({required this.bio});

  factory UpdateBioRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBioRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBioRequestToJson(this);
}
