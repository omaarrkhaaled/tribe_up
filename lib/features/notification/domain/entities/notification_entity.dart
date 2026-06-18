class NotificationEntity {
  final int? id;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? createdAt;
  final int? referenceId;
  final String? actorUserName;
  final String? actorPicture;

  const NotificationEntity({
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

  NotificationEntity copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? createdAt,
    int? referenceId,
    String? actorUserName,
    String? actorPicture,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      referenceId: referenceId ?? this.referenceId,
      actorUserName: actorUserName ?? this.actorUserName,
      actorPicture: actorPicture ?? this.actorPicture,
    );
  }

  factory NotificationEntity.fake() {
    return const NotificationEntity(
      id: 1,
      title: 'Notification',
      message: 'Omar liked your post',
      type: 'Notification',
      isRead: false,
      createdAt: '2 hours ago',
      referenceId: 1,
    );
  }
}
