import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';

class ChatInboxItemCard extends StatelessWidget {
  final ChatInboxItemEntity item;

  const ChatInboxItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final hasSender =
        item.lastMessageSenderName != null &&
        item.lastMessageSenderName!.isNotEmpty;
    final hasContent =
        item.lastMessageContent != null && item.lastMessageContent!.isNotEmpty;

    return InkWell(
      onTap: () {
        context.push(
          AppRoutesConstants.groupChat,
          extra: {
            'groupId': item.groupId,
            'groupName': item.groupName,
            'groupPicture': item.groupProfilePicture,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            _TribeAvatar(pictureUrl: item.groupProfilePicture),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.groupName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: ColorManager.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasSender || hasContent) ...[
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          if (hasSender)
                            TextSpan(
                              text: '${item.lastMessageSenderName}: ',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: ColorManager.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          if (hasContent)
                            TextSpan(
                              text: '"${item.lastMessageContent}"',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: ColorManager.lightGrey,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TribeAvatar extends StatelessWidget {
  final String? pictureUrl;

  const _TribeAvatar({this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    final isLoading = Skeletonizer.maybeOf(context)?.enabled ?? false;
    final hasImage =
        pictureUrl != null &&
        pictureUrl!.isNotEmpty &&
        pictureUrl!.startsWith('http');

    return Stack(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (hasImage || isLoading)
                ? null
                : LinearGradient(
                    colors: [ColorManager.primary, ColorManager.purpleDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: isLoading
                ? ColorManager.lightGrey.withValues(alpha: 0.2)
                : null,
            border: Border.all(
              color: isLoading
                  ? ColorManager.lightGrey.withValues(alpha: 0.2)
                  : ColorManager.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: (hasImage && !isLoading)
                ? CachedNetworkImage(
                    imageUrl: pictureUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _DefaultAvatar(),
                    errorWidget: (_, __, ___) => _DefaultAvatar(),
                  )
                : _DefaultAvatar(),
          ),
        ),
      ],
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = Skeletonizer.maybeOf(context)?.enabled ?? false;
    return Container(
      decoration: BoxDecoration(
        color: isLoading ? ColorManager.lightGrey.withValues(alpha: 0.2) : null,
        gradient: isLoading
            ? null
            : LinearGradient(
                colors: [ColorManager.primary, ColorManager.purpleDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: Icon(
        Icons.groups_rounded,
        color: isLoading ? Colors.transparent : Colors.white,
        size: 26,
      ),
    );
  }
}
