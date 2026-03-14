import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class EmptyCommentsWidget extends StatelessWidget {
  const EmptyCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FontAwesomeIcons.message, size: 70, color: ColorManager.grey),
        const SizedBox(height: 12),
        Text(
          UiConstants.noCommentsYet,
          style: textTheme.titleLarge?.copyWith(
            color: ColorManager.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          UiConstants.beTheFirstToComment,
          style: textTheme.bodyMedium?.copyWith(
            color: ColorManager.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
