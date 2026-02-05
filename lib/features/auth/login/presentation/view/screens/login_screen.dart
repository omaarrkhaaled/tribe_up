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
import 'package:tribe_up/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_states.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_ui_intents.dart';
import 'package:tribe_up/features/auth/login/presentation/view/widgets/email_field_widget.dart';
import 'package:tribe_up/features/auth/login/presentation/view/widgets/login_button_widget.dart';
import 'package:tribe_up/features/auth/login/presentation/view/widgets/password_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginCubit _loginCubit;
  final formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginCubit = getIt<LoginCubit>();
    _loginCubit.uiIntents.listen((event) {
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
        case NavigateToFeedIntent():
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(context, UiConstants.welocometotribeUp);
          context.pushNamed(AppRoutesConstants.feed);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: _loginCubit,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 7.h),
                        EmailFieldWidget(
                          controller: _email,
                          cubit: _loginCubit,
                        ),
                        SizedBox(height: 10.h),
                        PasswordFieldWidget(
                          password: _password,
                          cubit: _loginCubit,
                        ),
                        InkWell(
                          onTap: () => context.pushNamed(
                            AppRoutesConstants.forgetPassword,
                          ),
                          child: Text(
                            UiConstants.forgottenPassword,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<LoginCubit, LoginStates>(
                          builder: (_, state) {
                            return LoginButtonWidget(
                              cubit: _loginCubit,
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
                            onPressed: () {
                              context.pushReplacementNamed(
                                AppRoutesConstants.signUp,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.white,
                              foregroundColor: ColorManager.black,
                              side: BorderSide(color: ColorManager.black),
                            ),
                            child: Text(
                              UiConstants.createAccount,
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
    _email.dispose();
    _password.dispose();
  }
}
