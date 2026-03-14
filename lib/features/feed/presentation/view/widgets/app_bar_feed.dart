import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserSummaryEntity? userSummary;

  const FeedAppBar({super.key, this.userSummary});

  @override
  State<FeedAppBar> createState() => _FeedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FeedAppBarState extends State<FeedAppBar> {
  @override
  Widget build(BuildContext context) {
    final profilePic = widget.userSummary?.profilePicture;

    return AppBar(
      backgroundColor: ColorManager.white,
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: CircleAvatar(
              backgroundColor: ColorManager.white,
              foregroundImage: profilePic != null
                  ? CachedNetworkImageProvider(profilePic)
                  : null,
              child: Icon(Icons.person, color: ColorManager.grey),
            ),
          ),
        ),
      ),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          UiConstants.tribeUp,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
