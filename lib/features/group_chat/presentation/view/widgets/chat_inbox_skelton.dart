import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_inbox_item_card.dart';

class ChatInboxSkeleton extends StatelessWidget {
  const ChatInboxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyItems = List.generate(UiConstants.inboxSkeletonItemCount, (
      index,
    ) {
      return ChatInboxItemEntity(
        groupId: index,
        groupName: index % 2 == 0
            ? 'Tribe Name Placeholder'
            : 'Another Great Tribe',
        groupProfilePicture: '',
        lastMessageContent: index % 2 == 0
            ? 'Hey, what is the plan for today?'
            : 'Check out the new feed posts!',
        lastMessageSenderName: index % 2 == 0 ? 'Alice' : 'Bob',
      );
    });

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
        highlightColor: ColorManager.white.withValues(alpha: 0.6),
        duration: const Duration(milliseconds: 1200),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: dummyItems.length,
        separatorBuilder: (_, __) => Divider(
          color: ColorManager.lightGrey.withValues(alpha: 0.25),
          height: 1,
          thickness: 1,
        ),
        itemBuilder: (_, index) => ChatInboxItemCard(item: dummyItems[index]),
      ),
    );
  }
}
