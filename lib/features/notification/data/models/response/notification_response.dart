import 'package:json_annotation/json_annotation.dart';

import 'notification.dart';

@JsonSerializable()
class NotificationResponse {
  @JsonKey(name: 'notifications')
  List<Notification>? notifications;
  @JsonKey(name: 'unreadCount')
  int? unreadCount;

  NotificationResponse({this.notifications, this.unreadCount});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: json['unreadCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications?.map((e) => e.toJson()).toList(),
    'unreadCount': unreadCount,
  };
}
