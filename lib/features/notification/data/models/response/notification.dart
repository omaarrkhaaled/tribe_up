import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_entity.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'isRead')
  bool? isRead;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'referenceId')
  int? referenceId;
  @JsonKey(name: 'actorUserName')
  String? actorUserName;
  @JsonKey(name: 'actorPicture')
  String? actorPicture;

  Notification({
    this.id,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.referenceId,
    this.actorUserName,
    this.actorPicture,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead,
      createdAt: createdAt,
      referenceId: referenceId,
      actorUserName: actorUserName,
      actorPicture: actorPicture,
    );
  }
}
