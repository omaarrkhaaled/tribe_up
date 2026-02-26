import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class FeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
