import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart' show UiConstants;
import 'package:tribe_up/features/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/forget_password/domain/use_cases/forget_password_use_case.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/faorget_password_intents.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_passord_states.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/cubit/forget_password_ui_intents.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final StreamController<ForgetPasswordUiIntents> _uiController =
      StreamController.broadcast();
  Stream<ForgetPasswordUiIntents> get uiIntents => _uiController.stream;
  ForgetPasswordCubit(this._forgetPasswordUseCase)
    : super(ForgetPasswordStates());

  void doIntent(ForgetPasswordIntents intent) {
    switch (intent) {
      case EmailChangedIntent():
        _emailChanged(intent.email);
        break;
      case ConfirmEmailIntent():
        _confirmEmail();
        break;
      case ResendLinkIntent():
        _resendLink(intent.email);
        break;
    }
  }

  void _emailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        isValidForm: _validate(email: email),
      ),
    );
  }

  bool? _validate({required String email}) {
    return email.isNotEmpty;
  }

  Future<void> _confirmEmail() async {
    if (state.email.isEmpty) {
      _uiController.add(ShowErrorIntent(UiConstants.pleaseEnterYourEmail));
      return;
    }

    _uiController.add(ShowLoadingIntent());

    final request = ForgetPasswordRequestEntity(email: state.email);

    final response = await _forgetPasswordUseCase(request);

    switch (response) {
      case SuccessResponse():
        _uiController.add(NavigateToVerifyIntent());
        break;
      case ErrorResponse():
        _uiController.add(ShowErrorIntent(response.error.message));
        break;
    }
  }

  Future<void> _resendLink(String? email) async {
    final targetEmail = email ?? state.email;
    if (targetEmail.isEmpty) {
      _uiController.add(ShowErrorIntent(UiConstants.pleaseEnterYourEmail));
      return;
    }

    _uiController.add(ShowLoadingIntent());

    final request = ForgetPasswordRequestEntity(email: targetEmail);

    final response = await _forgetPasswordUseCase(request);

    switch (response) {
      case SuccessResponse():
        _uiController.add(SuccessIntent(UiConstants.emailSentSuccessfully));
        break;
      case ErrorResponse():
        _uiController.add(ShowErrorIntent(response.error.message));
        break;
    }
  }
}
