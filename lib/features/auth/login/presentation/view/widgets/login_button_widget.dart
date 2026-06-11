import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_intents.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_states.dart';

class LoginButtonWidget extends StatelessWidget {
  final LoginCubit cubit;
  final GlobalKey<FormState> formKey;
  final LoginStates state;

  const LoginButtonWidget({
    super.key,
    required this.cubit,
    required this.formKey,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isFormValid
            ? () {
                if (formKey.currentState!.validate()) {
                  cubit.doIntent(LoginIntent());
                }
              }
            : null,
        child: Text(
          UiConstants.login,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ColorManager.white,
              ),
        ),
      ),
    );
  }
}
