import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_intents.dart';

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final LoginCubit cubit;

  const EmailFieldWidget({
    super.key,
    required this.controller,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: UiConstants.email,
        hintText: UiConstants.enterEmail,
      ),
      validator: (v) => Validator.validateEmail(v),
      onChanged: (v) => cubit.doIntent(EmailChanged(v)),
    );
  }
}
