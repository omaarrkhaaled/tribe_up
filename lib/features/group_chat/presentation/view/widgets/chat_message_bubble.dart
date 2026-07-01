import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;
  final bool showSenderInfo;
  final bool isEditing;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final VoidCallback onLongPress;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.showSenderInfo,
    this.isEditing = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isFirstInGroup ? 10 : 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _SenderAvatar(
              avatarUrl: message.senderProfilePicture,
              name: message.senderName,
              visible: showSenderInfo,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe && showSenderInfo) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      '@${message.senderName}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ColorManager.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                GestureDetector(
                  onLongPress: onLongPress,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isMe ? ColorManager.purpleDark : Colors.white,
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              bottomLeft: const Radius.circular(20),
                              topRight: Radius.circular(
                                isFirstInGroup ? 20 : 2,
                              ),
                              bottomRight: Radius.circular(
                                isLastInGroup ? 20 : 2,
                              ),
                            )
                          : BorderRadius.only(
                              topRight: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                              topLeft: Radius.circular(isFirstInGroup ? 20 : 2),
                              bottomLeft: Radius.circular(
                                isLastInGroup ? 20 : 2,
                              ),
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: isMe
                              ? ColorManager.purpleDark.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: isEditing
                          ? Border.all(color: ColorManager.amber, width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.content,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isMe ? Colors.white : ColorManager.black,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.isEdited) ...[
                              Text(
                                'edited • ',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: isMe
                                          ? Colors.white.withValues(alpha: 0.6)
                                          : ColorManager.lightGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                            Text(
                              _formatTime(message.sentAt),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: isMe
                                        ? Colors.white.withValues(alpha: 0.7)
                                        : ColorManager.lightGrey,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final hourStr = hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$min $period';
  }
}

class _SenderAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final bool visible;

  const _SenderAvatar({
    this.avatarUrl,
    required this.name,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox(width: 34);

    final hasImage =
        avatarUrl != null &&
        avatarUrl!.isNotEmpty &&
        avatarUrl!.startsWith('http');

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorManager.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: ColorManager.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _InitialsAvatar(name: name),
                errorWidget: (_, __, ___) => _InitialsAvatar(name: name),
              )
            : _InitialsAvatar(name: name),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: ColorManager.primary.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: ColorManager.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
