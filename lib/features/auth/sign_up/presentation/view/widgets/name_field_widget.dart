import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_intents.dart';

class NameFieldsWidget extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final SignUpCubit cubit;

  const NameFieldsWidget({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: firstName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: UiConstants.firstName,
              hintText: UiConstants.enterFirstName,
              helperText: '',
            ),
            validator: Validator.validateName,
            onChanged: (v) => cubit.doIntent(FirstNameChanged(v)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: lastName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: UiConstants.lastName,
              hintText: UiConstants.enterLastName,
              helperText: '',
            ),
            validator: Validator.validateName,
            onChanged: (v) => cubit.doIntent(LastNameChanged(v)),
          ),
        ),
      ],
    );
  }
}
