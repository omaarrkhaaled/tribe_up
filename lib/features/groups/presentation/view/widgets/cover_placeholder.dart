import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primary.withValues(alpha: 0.15),
      child: Icon(
        Icons.groups_2_outlined,
        size: 64,
        color: ColorManager.primary.withValues(alpha: 0.3),
      ),
    );
  }
}
