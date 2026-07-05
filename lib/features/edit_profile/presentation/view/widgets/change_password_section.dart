import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UiConstants.password,
                  style: textTheme.titleLarge?.copyWith(
                    color: ColorManager.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(6, (index) {
                    return Icon(
                      Icons.star,
                      color: ColorManager.black,
                      size: 14,
                    );
                  }),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                context.pushNamed(AppRoutesConstants.changePassword),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
            ),
            child: Text(
              UiConstants.changePassword,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorManager.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
