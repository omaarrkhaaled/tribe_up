import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String groupName;
  final String? groupPicture;

  const ChatAppBar({super.key, required this.groupName, this.groupPicture});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final hasImage =
        groupPicture != null &&
        groupPicture!.isNotEmpty &&
        groupPicture!.startsWith('http');

    return AppBar(
      backgroundColor: ColorManager.primary,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorManager.white,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorManager.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: groupPicture!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _DefaultGroupIcon(),
                      errorWidget: (_, __, ___) => _DefaultGroupIcon(),
                    )
                  : _DefaultGroupIcon(),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                groupName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: ColorManager.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    UiConstants.activeNow,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorManager.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefaultGroupIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.white.withValues(alpha: 0.15),
      child: Icon(Icons.groups_rounded, color: ColorManager.white, size: 20),
    );
  }
}
