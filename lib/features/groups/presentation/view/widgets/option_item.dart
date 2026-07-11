import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int selected;
  final ValueChanged<int> onChanged;
  const OptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.primary.withValues(alpha: 0.08)
                : ColorManager.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ColorManager.primary : ColorManager.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? ColorManager.primary : ColorManager.grey,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? ColorManager.primary : ColorManager.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
