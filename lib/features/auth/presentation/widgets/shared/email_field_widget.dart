import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const EmailFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: const InputDecoration(
        labelText: UiConstants.email,
        hintText: UiConstants.enterEmail,
        helperText: '',
      ),
      validator: (v) => Validator.validateEmail(v),
      onChanged: onChanged,
    );
  }
}
