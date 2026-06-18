import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class NotificationSkeletonCard extends StatelessWidget {
  const NotificationSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: ColorManager.notificationUnreadBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorManager.lightGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(2, 2),
          ),
        ],
        border: Border.all(color: ColorManager.white, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone.circle(size: 44),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Bone.text(words: 5),
                  const SizedBox(height: 8),
                  Bone.text(words: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
