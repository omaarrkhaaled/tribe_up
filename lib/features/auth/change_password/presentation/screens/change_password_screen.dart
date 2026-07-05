import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_password_cubit.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_password_intents.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_pasword_ui_intents.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final ChangePasswordCubit _passwordCubit;
  final formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newpassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordCubit = getIt<ChangePasswordCubit>();

    _currentPassword.addListener(() {
      _passwordCubit.doIntent(CurrentPasswordChanged(_currentPassword.text));
    });

    _newpassword.addListener(() {
      _passwordCubit.doIntent(NewPasswordChanged(_newpassword.text));
    });

    _confirmPassword.addListener(() {
      _passwordCubit.doIntent(ConfirmPasswordChanged(_confirmPassword.text));
    });

    _passwordCubit.uiInenet.listen((intent) {
      if (!mounted) return;

      switch (intent) {
        case ShowLoadingIntent():
          UIUtils.showDotLottieLoadingOverlay(context);
          break;

        case ShowErrorIntent():
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(
            context,
            intent.message,
            backgroundColor: ColorManager.red,
          );
          break;
        case NavigateToEditProfileIntent():
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(
            context,
            UiConstants.passwordUpdatedSuccessfully,
            backgroundColor: ColorManager.primary,
            icon: Icons.check_circle_outline_rounded,
          );
          context.pop();
          break;
      }
    });
  }

  @override
  void dispose() {
    _passwordCubit.close();
    _currentPassword.dispose();
    _newpassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _passwordCubit,
      child: Scaffold(
        appBar: AppBar(title: Text(UiConstants.changePassword)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: _currentPassword,
                  decoration: InputDecoration(
                    label: Text(UiConstants.currentPassword),
                    hintText: UiConstants.currentPassword,
                    helperText: '',
                  ),
                  validator: Validator.validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _newpassword,
                  decoration: InputDecoration(
                    label: Text(UiConstants.newPassword),
                    hintText: UiConstants.newPassword,
                    helperText: '',
                  ),
                  validator: Validator.validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: _confirmPassword,
                  decoration: InputDecoration(
                    label: Text(UiConstants.confirmPassword),
                    hintText: UiConstants.confirmPassword,
                    helperText: '',
                  ),
                  validator: (value) => Validator.validateConfirmPassword(
                    value,
                    _newpassword.text,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 40),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _passwordCubit.doIntent(UpdateIntent());
                      }
                    },
                    child: Text(
                      UiConstants.updatePassword,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
