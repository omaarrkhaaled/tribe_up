import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/widgets/create_post_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_cubit.dart';

class FeedCreatePostTrigger extends StatefulWidget {
  final FeedStates state;
  final String? userProfilePicture;

  const FeedCreatePostTrigger({
    super.key,
    required this.state,
    this.userProfilePicture,
  });

  @override
  State<FeedCreatePostTrigger> createState() => _FeedCreatePostTriggerState();
}

class _FeedCreatePostTriggerState extends State<FeedCreatePostTrigger> {
  Future<void> _openCreatePost(BuildContext context) async {
    final post = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatePostSheet(groups: widget.state.joinedGroups),
    );

    if (post != null && context.mounted) {
      context.read<FeedCubit>().doIntent(PostCreatedIntent(post));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: ColorManager.lightGrey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Avatar + What's on your mind row ---
          GestureDetector(
            onTap: () => _openCreatePost(context),
            child: Row(
              children: [
                _UserAvatar(profilePicture: widget.userProfilePicture),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.lightGrey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ColorManager.lightGrey.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      UiConstants.whatsOnYourMind,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Private sub-widgets ----------

class _UserAvatar extends StatelessWidget {
  final String? profilePicture;
  const _UserAvatar({this.profilePicture});

  @override
  Widget build(BuildContext context) {
    final hasValidUrl =
        profilePicture != null &&
        profilePicture!.isNotEmpty &&
        profilePicture != 'null' &&
        profilePicture!.startsWith('http');

    return CircleAvatar(
      radius: 20,
      backgroundColor: ColorManager.lightGrey.withValues(alpha: 0.4),
      backgroundImage: hasValidUrl
          ? CachedNetworkImageProvider(profilePicture!)
          : null,
      child: hasValidUrl
          ? null
          : Icon(Icons.person, color: ColorManager.grey, size: 20),
    );
  }
}
