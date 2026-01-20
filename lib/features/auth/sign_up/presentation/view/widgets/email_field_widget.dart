import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_intents.dart';

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final SignUpCubit cubit;

  const EmailFieldWidget({
    super.key,
    required this.controller,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
