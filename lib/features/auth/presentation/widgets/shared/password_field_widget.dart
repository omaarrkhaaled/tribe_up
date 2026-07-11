import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController password;
  final void Function(String) onChanged;

  const PasswordFieldWidget({
    super.key,
    required this.password,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: UiConstants.password,
            hintText: UiConstants.enterPassword,
            helperText: '',
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
