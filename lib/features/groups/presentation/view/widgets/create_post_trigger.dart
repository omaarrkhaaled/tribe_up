import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/feed/presentation/widgets/create_post_sheet.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_intents.dart';

class CreatePostTrigger extends StatefulWidget {
  final Group tribe;
  final TribeProfileCubit cubit;
  final String? userProfilePicture;
  const CreatePostTrigger({
    super.key,
    required this.tribe,
    required this.cubit,
    this.userProfilePicture,
  });

  @override
  State<CreatePostTrigger> createState() => _CreatePostTriggerState();
}

class _CreatePostTriggerState extends State<CreatePostTrigger> {
  late TextTheme textTheme;

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: ColorManager.transparent,
          builder: (_) => CreatePostSheet(groupId: widget.tribe.id!),
        ).then((result) {
          if (result != null) {
            widget.cubit.doIntent(AddCreatedPostIntent(result));
          } else {
            widget.cubit.doIntent(LoadTribePostsIntent(widget.tribe.id!));
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorManager.lightGrey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: ColorManager.primary.withValues(alpha: 0.2),
              foregroundImage: widget.userProfilePicture != null
                  ? CachedNetworkImageProvider(widget.userProfilePicture!)
                  : null,
              child: Icon(Icons.person, color: ColorManager.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                UiConstants.whatIsInYourMind,
                style: textTheme.titleMedium?.copyWith(
                  color: ColorManager.black.withValues(alpha: 0.8),
                ),
              ),
            ),
            Icon(Icons.image_outlined, color: ColorManager.grey),
          ],
        ),
      ),
    );
  }
}
