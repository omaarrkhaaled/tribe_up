import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_intents.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController password;
  final LoginCubit cubit;

  const PasswordFieldWidget({
    super.key,
    required this.password,
    required this.cubit,
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
          onChanged: (v) => cubit.doIntent(PasswordChanged(v)),
        ),
      ],
    );
  }
}
