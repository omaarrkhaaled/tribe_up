import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';

class TribeFollowerTile extends StatelessWidget {
  final GroupFollowerResultDTO follower;
  final bool isAdmin;
  final VoidCallback? onRemove;

  const TribeFollowerTile({
    super.key,
    required this.follower,
    required this.isAdmin,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: follower.profilePictureUrl != null
            ? CachedNetworkImageProvider(follower.profilePictureUrl!)
            : null,
        backgroundColor: ColorManager.primary.withValues(alpha: 0.15),
        child: follower.profilePictureUrl == null
            ? Icon(Icons.person, color: ColorManager.primary, size: 22)
            : null,
      ),
      title: Text(
        follower.userName ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: ColorManager.black,
        ),
      ),
      trailing: isAdmin
          ? IconButton(
              icon: Icon(
                Icons.person_remove_outlined,
                color: ColorManager.red,
                size: 20,
              ),
              tooltip: UiConstants.removeFollower,
              onPressed: onRemove,
            )
          : null,
    );
  }
}
