import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ExpiryDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final bool enabled;
  final VoidCallback? onTap;

  const ExpiryDatePicker({
    super.key,
    required this.selectedDate,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = selectedDate == null
        ? ''
        : '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          UiConstants.expireAt,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: selectedDate == null ? 'mm/dd/yyyy' : displayDate,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selectedDate == null
                      ? ColorManager.lightGrey
                      : ColorManager.black,
                ),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: enabled ? ColorManager.grey : ColorManager.lightGrey,
                  size: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorManager.lightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorManager.lightGrey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: ColorManager.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              controller: TextEditingController(text: displayDate),
            ),
          ),
        ),
      ],
    );
  }
}
