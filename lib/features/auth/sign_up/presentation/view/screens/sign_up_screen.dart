import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/resources/font_managar.dart';
import 'package:tribe_up/core/resources/styles_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_states.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/cubit/sign_up_ui_intents.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/widgets/email_field_widget.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/widgets/name_field_widget.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/widgets/password_field_widget.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/widgets/sign_up_button_widget.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/widgets/user_name_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpCubit _signUpCubit;
  final formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signUpCubit = getIt<SignUpCubit>();
    _signUpCubit.uiIntents.listen((event) {
      if (!mounted) return;

      switch (event) {
        case ShowLoadingIntent():
          UIUtils.showDotLottieLoadingOverlay(context);

        case ShowErrorIntent(message: final message):
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(
            context,
            message,
            backgroundColor: ColorManager.red,
            icon: Icons.error,
          );
          break;
        case NavigateToFeedIntent(message: final message):
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(context, message);
          context.pushNamed(AppRoutesConstants.feed);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: _signUpCubit,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Text(
                    UiConstants.createAccountMessage,
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        NameFieldsWidget(
                          firstName: _firstName,
                          lastName: _lastName,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 7.h),
                        EmailFieldWidget(
                          controller: _email,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 16.h),
                        UserNameFieldWidget(
                          controller: _userName,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 16.h),
                        PasswordFieldsWidget(
                          password: _password,
                          confirmPassword: _confirmPassword,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 20.h),
                        BlocBuilder<SignUpCubit, SignUpStates>(
                          builder: (_, state) {
                            return SignUpButtonWidget(
                              cubit: _signUpCubit,
                              formKey: formKey,
                              state: state,
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.white,
                              foregroundColor: ColorManager.black,
                              side: BorderSide(color: ColorManager.black),
                            ),
                            child: Text(
                              UiConstants.alreadyHaveAccount,
                              style: getMediumStyle(
                                fontSize: 18.sp,
                                color: ColorManager.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 80.h),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            UiConstants.tribeUp,
                            style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _signUpCubit.close();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _userName.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }
}
