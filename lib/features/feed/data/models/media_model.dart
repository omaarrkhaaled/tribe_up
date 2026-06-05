import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/feed/domain/entities/media_entity.dart';

part 'media_model.g.dart';

@JsonSerializable()
class MediaModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'mediaURL')
  final String mediaURL;
  @JsonKey(name: 'type')
  final String mediaType;
  @JsonKey(name: 'order')
  final int order;

  MediaModel({
    required this.id,
    required this.mediaURL,
    required this.mediaType,
    required this.order,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  MediaEntity toEntity() {
    return MediaEntity(
      id: id,
      mediaURL: mediaURL,
      mediaType: mediaType,
      order: order,
    );
  }
}
