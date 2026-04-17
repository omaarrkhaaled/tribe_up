import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';
import 'notification.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  @JsonKey(name: 'notifications')
  List<Notification>? notifications;
  @JsonKey(name: 'unreadCount')
  int? unreadCount;

  NotificationResponse({this.notifications, this.unreadCount});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

  NotificationResponseEntity toEntity() {
    return NotificationResponseEntity(
      notifications: notifications?.map((e) => e.toEntity()).toList(),
      unreadCount: unreadCount,
    );
  }
}
