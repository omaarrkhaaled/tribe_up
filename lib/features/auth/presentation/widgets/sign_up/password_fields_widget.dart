import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';

class PasswordFieldsWidget extends StatefulWidget {
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
  State<PasswordFieldsWidget> createState() => _PasswordFieldsWidgetState();
}

class _PasswordFieldsWidgetState extends State<PasswordFieldsWidget> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.password,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: UiConstants.password,
            hintText: UiConstants.enterPassword,
            helperText: '',
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: Validator.validatePassword,
          onChanged: widget.onPasswordChanged,
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: widget.confirmPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            labelText: UiConstants.confirmPassword,
            hintText: UiConstants.confirmPassword,
            helperText: '',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          validator: (v) =>
              Validator.validateConfirmPassword(v, widget.password.text),
          onChanged: widget.onConfirmPasswordChanged,
        ),
      ],
    );
  }
}
