import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_intents.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_states.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_ui_intents.dart';
import 'package:tribe_up/features/auth/presentation/widgets/shared/email_field_widget.dart';
import 'package:tribe_up/features/auth/presentation/widgets/sign_up/name_field_widget.dart';
import 'package:tribe_up/features/auth/presentation/widgets/sign_up/password_fields_widget.dart';
import 'package:tribe_up/features/auth/presentation/widgets/sign_up/sign_up_button_widget.dart';
import 'package:tribe_up/features/auth/presentation/widgets/sign_up/user_name_field_widget.dart';

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
        case NavigateToLoginIntent(message: final message):
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(context, message);
          context.pushReplacementNamed(AppRoutesConstants.login);
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
                  SizedBox(height: 15),
                  Text(
                    UiConstants.createAccountMessage,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        NameFieldsWidget(
                          firstName: _firstName,
                          lastName: _lastName,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 5),
                        EmailFieldWidget(
                          controller: _email,
                          onChanged: (v) =>
                              _signUpCubit.doIntent(EmailChanged(v)),
                        ),
                        SizedBox(height: 5),
                        UserNameFieldWidget(
                          controller: _userName,
                          cubit: _signUpCubit,
                        ),
                        SizedBox(height: 5),
                        PasswordFieldsWidget(
                          password: _password,
                          confirmPassword: _confirmPassword,
                          onPasswordChanged: (v) =>
                              _signUpCubit.doIntent(PasswordChanged(v)),
                          onConfirmPasswordChanged: (v) =>
                              _signUpCubit.doIntent(ConfirmPasswordChanged(v)),
                        ),
                        SizedBox(height: 5),
                        BlocBuilder<SignUpCubit, SignUpStates>(
                          builder: (_, state) {
                            return SignUpButtonWidget(
                              cubit: _signUpCubit,
                              formKey: formKey,
                              state: state,
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pushReplacementNamed(
                                AppRoutesConstants.login,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.white,
                              foregroundColor: ColorManager.black,
                              side: BorderSide(color: ColorManager.black),
                            ),
                            child: Text(
                              UiConstants.alreadyHaveAccount,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 150),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            UiConstants.tribeUp,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
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
