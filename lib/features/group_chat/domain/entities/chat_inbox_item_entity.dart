import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

class ChatInboxItemEntity extends Equatable {
  final int groupId;
  final String groupName;
  final String? groupPicture;
  final ChatMessageEntity? lastMessage;
  final int unreadCount;

  const ChatInboxItemEntity({
    required this.groupId,
    required this.groupName,
    this.groupPicture,
    this.lastMessage,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    groupPicture,
    lastMessage,
    unreadCount,
  ];
}
