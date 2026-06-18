import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_intents.dart';

class PasswordFieldsWidget extends StatelessWidget {
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final SignUpCubit cubit;

  const PasswordFieldsWidget({
    super.key,
    required this.password,
    required this.confirmPassword,
    required this.cubit,
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
          onChanged: (v) => cubit.doIntent(PasswordChanged(v)),
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
          onChanged: (v) => cubit.doIntent(ConfirmPasswordChanged(v)),
        ),
      ],
    );
  }
}
