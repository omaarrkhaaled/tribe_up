import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_intents.dart';

class ConfirmDeleteTribeDialog extends StatelessWidget {
  final Group tribe;
  final TribeSettingsCubit cubit;

  const ConfirmDeleteTribeDialog({
    super.key,
    required this.tribe,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: ColorManager.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                color: ColorManager.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              UiConstants.deleteTribe,
              style: textTheme.titleLarge?.copyWith(
                color: ColorManager.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              UiConstants.confirmDeleteTribe,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorManager.black.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: ColorManager.black.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      UiConstants.cancel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.red,
                      foregroundColor: ColorManager.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      EasyLoading.show();
                      cubit.doIntent(DeleteTribeIntent(tribe.id!));
                    },
                    child: Text(
                      UiConstants.delete,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
