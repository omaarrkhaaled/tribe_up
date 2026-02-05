import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/faorget_password_intents.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_passord_states.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_password_ui_intents.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late final ForgetPasswordCubit _forgetPasswordCubit;
  @override
  void initState() {
    super.initState();
    _forgetPasswordCubit = getIt<ForgetPasswordCubit>();
    _forgetPasswordCubit.doIntent(EmailChangedIntent(widget.email));
    _forgetPasswordCubit.uiIntents.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowLoadingIntent():
          UIUtils.showDotLottieLoadingOverlay(context);
          break;
        case ShowErrorIntent(errorMessage: final errorMessage):
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(
            context,
            errorMessage,
            backgroundColor: ColorManager.red,
            icon: Icons.error,
          );
          break;
        case SuccessIntent(message: final message):
          UIUtils.hideLoading(context);
          UIUtils.showPremiumMessage(context, message);
          break;
        case HideLoadingIntent():
          UIUtils.hideLoading(context);
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocProvider.value(
            value: _forgetPasswordCubit,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 65,
                    color: ColorManager.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  UiConstants.emailSent,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  UiConstants.weSentPasswordResetInstructionsTo,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: ColorManager.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutesConstants.login),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorManager.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      UiConstants.backToLogin,
                      style: TextStyle(
                        color: ColorManager.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          _forgetPasswordCubit.doIntent(
                            ResendLinkIntent(email: widget.email),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          UiConstants.resendEmail,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: ColorManager.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      );
                    },
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
