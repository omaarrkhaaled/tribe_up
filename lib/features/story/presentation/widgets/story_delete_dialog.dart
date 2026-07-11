import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';

class StoryDeleteDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const StoryDeleteDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StoryDeleteDialog(
        onCancel: () {
          Navigator.pop(dialogCtx);
          onCancel();
        },
        onConfirm: () {
          Navigator.pop(dialogCtx);
          onConfirm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        UiConstants.delete,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        UiConstants.deleteStoryMessage,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            UiConstants.cancel,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            UiConstants.delete,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
