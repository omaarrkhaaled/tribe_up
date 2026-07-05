import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_message_bubble.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_states.dart';

class ChatMessagesList extends StatelessWidget {
  final GroupChatStates state;
  final String? currentUserId;
  final ScrollController scrollController;
  final void Function(ChatMessageEntity message) onMessageLongPress;

  const ChatMessagesList({
    super.key,
    required this.state,
    required this.currentUserId,
    required this.scrollController,
    required this.onMessageLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return _ChatSkeleton();
    }

    if (state.messages.isEmpty) {
      return _ChatEmpty();
    }

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: state.messages.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final message = state.messages[index];
        final isMe = message.senderId == currentUserId;

        final bool showSender =
            index == state.messages.length - 1 ||
            state.messages[index + 1].senderId != message.senderId;

        bool showDateHeader = false;
        bool isFirstInGroup = false;

        if (index == state.messages.length - 1) {
          showDateHeader = true;
          isFirstInGroup = true;
        } else {
          final prevMsg = state.messages[index + 1];
          if (!_isSameDay(message.sentAt, prevMsg.sentAt)) {
            showDateHeader = true;
            isFirstInGroup = true;
          } else if (prevMsg.senderId != message.senderId) {
            isFirstInGroup = true;
          }
        }

        bool isLastInGroup = false;
        if (index == 0) {
          isLastInGroup = true;
        } else {
          final nextMsg = state.messages[index - 1];
          if (nextMsg.senderId != message.senderId) {
            isLastInGroup = true;
          } else if (!_isSameDay(message.sentAt, nextMsg.sentAt)) {
            isLastInGroup = true;
          }
        }

        Widget bubble = ChatMessageBubble(
          message: message,
          isMe: isMe,
          showSenderInfo: showSender,
          isEditing: state.editingMessageId == message.id,
          isFirstInGroup: isFirstInGroup,
          isLastInGroup: isLastInGroup,
          onLongPress: () => onMessageLongPress(message),
        );

        if (showDateHeader) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildDateHeader(context, message.sentAt), bubble],
          );
        }

        return bubble;
      },
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    String dateString;
    if (msgDate == today) {
      dateString = 'Today';
    } else if (msgDate == yesterday) {
      dateString = 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      dateString = '${months[date.month - 1]} ${date.day}, ${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: ColorManager.lightGrey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          dateString,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ColorManager.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ChatSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dummyMessages = List.generate(UiConstants.chatSkeletonItemCount, (
      index,
    ) {
      final isMe = index % 2 == 0;
      return ChatMessageEntity(
        id: index,
        groupId: 1,
        senderId: isMe ? 'me' : 'other',
        senderName: isMe ? 'Me' : 'Tribe Member',
        senderProfilePicture: '',
        content: index % 3 == 0
            ? 'Short message.'
            : (index % 3 == 1
                  ? 'This is a slightly longer dummy message for skeleton.'
                  : 'A very long message to make the chat history skeleton loader look realistic and premium.'),
        sentAt: DateTime.now(),
        isEdited: false,
      );
    });

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
        highlightColor: ColorManager.white.withValues(alpha: 0.6),
        duration: const Duration(milliseconds: 1200),
      ),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: dummyMessages.length,
        itemBuilder: (context, index) {
          final message = dummyMessages[index];
          final isMe = message.senderId == 'me';
          return ChatMessageBubble(
            message: message,
            isMe: isMe,
            showSenderInfo: !isMe,
            isFirstInGroup: true,
            isLastInGroup: true,
            onLongPress: () {},
          );
        },
      ),
    );
  }
}

class _ChatEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManager.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_rounded,
              size: 52,
              color: ColorManager.primary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            UiConstants.noMessagesYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorManager.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            UiConstants.sayHiToStart,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ColorManager.lightGrey),
          ),
        ],
      ),
    );
  }
}
