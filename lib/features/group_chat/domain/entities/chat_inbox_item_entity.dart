import 'package:equatable/equatable.dart';

class ChatInboxItemEntity extends Equatable {
  final int groupId;
  final String groupName;
  final String? groupProfilePicture;
  final String? lastMessageContent;
  final String? lastMessageSenderName;
  final DateTime? lastMessageSentAt;

  const ChatInboxItemEntity({
    required this.groupId,
    required this.groupName,
    this.groupProfilePicture,
    this.lastMessageContent,
    this.lastMessageSenderName,
    this.lastMessageSentAt,
  });

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    groupProfilePicture,
    lastMessageContent,
    lastMessageSenderName,
    lastMessageSentAt,
  ];
}
