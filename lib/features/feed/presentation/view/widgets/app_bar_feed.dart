import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserSummaryEntity? userSummary;
  final VoidCallback? onMenuTap;

  const FeedAppBar({super.key, this.userSummary, this.onMenuTap});

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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onMenuTap,
          child: Center(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: ColorManager.white,
              backgroundImage: profilePic != null
                  ? CachedNetworkImageProvider(profilePic)
                  : null,
              child: profilePic == null
                  ? Icon(Icons.person, color: ColorManager.grey)
                  : null,
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
