import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/resources/styles_manager.dart';

import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_intents.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_states.dart';

class SignUpButtonWidget extends StatelessWidget {
  final SignUpCubit cubit;
  final GlobalKey<FormState> formKey;
  final SignUpStates state;

  const SignUpButtonWidget({
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
                  cubit.doIntent(SignUpIntent());
                }
              }
            : null,
        child: Text(
          UiConstants.createAccount,
          style: getMediumStyle(color: ColorManager.white, fontSize: 18.sp),
        ),
      ),
    );
  }
}
