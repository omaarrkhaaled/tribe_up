import 'package:json_annotation/json_annotation.dart';

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

  Notification({
    this.id,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.referenceId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json['id'] as int?,
    title: json['title'] as String?,
    message: json['message'] as String?,
    type: json['type'] as String?,
    isRead: json['isRead'] as bool?,
    createdAt: json['createdAt'] as String?,
    referenceId: json['referenceId'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'isRead': isRead,
    'createdAt': createdAt,
    'referenceId': referenceId,
  };
}
