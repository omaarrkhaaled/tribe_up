import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_intents.dart';

class UserNameFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final SignUpCubit cubit;

  const UserNameFieldWidget({
    super.key,
    required this.controller,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: UiConstants.userName,
        hintText: UiConstants.enterUserName,
        helperText: '',
      ),
      validator: (v) => Validator.validateUsername(v),
      onChanged: (v) => cubit.doIntent(UserNameChanged(v)),
    );
  }
}
