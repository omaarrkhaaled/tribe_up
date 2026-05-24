import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/option_item.dart';

class PrivacyRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const PrivacyRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OptionItem(
          icon: Icons.public,
          label: UiConstants.public,
          value: 0,
          selected: selected,
          onChanged: onChanged,
        ),
        const SizedBox(width: 12),
        OptionItem(
          icon: Icons.lock_outline,
          label: UiConstants.private,
          value: 1,
          selected: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
