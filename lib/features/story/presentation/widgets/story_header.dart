import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';

class StoryHeader extends StatelessWidget {
  final StoryEntity story;
  final String currentGroupName;
  final bool isOwner;
  final VoidCallback onDeleteTap;
  final VoidCallback onCloseTap;

  const StoryHeader({
    super.key,
    required this.story,
    required this.currentGroupName,
    required this.isOwner,
    required this.onDeleteTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
          backgroundImage:
              (story.groupProfilePicture != null &&
                  story.groupProfilePicture!.startsWith('http'))
              ? CachedNetworkImageProvider(story.groupProfilePicture!)
              : null,
          child:
              (story.groupProfilePicture == null ||
                  !story.groupProfilePicture!.startsWith('http'))
              ? const Icon(Icons.groups, color: Colors.white, size: 18)
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentGroupName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (story.creatorUserName != null)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          userName: story.creatorUserName ?? '',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'by @${story.creatorUserName}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        if (isOwner)
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 26,
            ),
            onPressed: onDeleteTap,
          ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: onCloseTap,
        ),
      ],
    );
  }
}
