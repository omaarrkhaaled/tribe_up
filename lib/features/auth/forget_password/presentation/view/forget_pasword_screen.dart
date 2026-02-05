import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/core/utils/validator.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/faorget_password_intents.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_passord_states.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_password_ui_intents.dart';

class ForgetPaswordScreen extends StatefulWidget {
  const ForgetPaswordScreen({super.key});

  @override
  State<ForgetPaswordScreen> createState() => _ForgetPaswordScreenState();
}

class _ForgetPaswordScreenState extends State<ForgetPaswordScreen> {
  late ForgetPasswordCubit _forgetPasswordCubit;
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _forgetPasswordCubit = getIt<ForgetPasswordCubit>();
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
        case NavigateToVerifyIntent():
          UIUtils.hideLoading(context);
          context.pushNamed(
            AppRoutesConstants.verifyEmail,
            extra: _emailController.text,
          );
          break;
        case HideLoadingIntent():
          UIUtils.hideLoading(context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UiConstants.password)),
      body: Center(
        child: BlocProvider.value(
          value: _forgetPasswordCubit,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    UiConstants.forgetPasswordHeadLine,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    UiConstants.pleaseEnterYourEmailAssociatedToYourAccount,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: ColorManager.grey),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    validator: Validator.validateEmail,
                    onChanged: (value) {
                      _forgetPasswordCubit.doIntent(EmailChangedIntent(value));
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: UiConstants.enterEmail,
                      labelText: UiConstants.email,
                      helperText: '',
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child:
                        BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _forgetPasswordCubit.doIntent(
                                    ConfirmEmailIntent(),
                                  );
                                }
                              },
                              child: Text(UiConstants.confirm),
                            );
                          },
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
}
