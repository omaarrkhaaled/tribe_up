import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ChatInboxEmpty extends StatelessWidget {
  const ChatInboxEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 72,
            color: ColorManager.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            UiConstants.noConversationsYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorManager.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            UiConstants.joinTribeToChat,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ColorManager.lightGrey),
          ),
        ],
      ),
    );
  }
}
