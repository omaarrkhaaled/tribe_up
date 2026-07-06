import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';

class PasswordFieldsWidget extends StatelessWidget {
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final void Function(String) onPasswordChanged;
  final void Function(String) onConfirmPasswordChanged;

  const PasswordFieldsWidget({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: password,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: UiConstants.password,
            hintText: UiConstants.enterPassword,
            helperText: '',
          ),
          validator: Validator.validatePassword,
          onChanged: onPasswordChanged,
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: confirmPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: UiConstants.confirmPassword,
            hintText: UiConstants.confirmPassword,
            helperText: '',
          ),
          validator: (v) => Validator.validateConfirmPassword(v, password.text),
          onChanged: onConfirmPasswordChanged,
        ),
      ],
    );
  }
}
