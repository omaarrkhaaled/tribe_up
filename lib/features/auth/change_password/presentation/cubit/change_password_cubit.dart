import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/auth/change_password/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/change_password/domain/use_cases/change_password_use_case.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_password_intents.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_password_states.dart';
import 'package:tribe_up/features/auth/change_password/presentation/cubit/change_pasword_ui_intents.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  final ChangePasswordUseCase _passwordUseCase;
  final StreamController<ChangePaswordUiIntents> _streamController =
      StreamController();

  Stream<ChangePaswordUiIntents> get uiInenet => _streamController.stream;

  ChangePasswordCubit(this._passwordUseCase) : super(ChangePasswordStates());

  void doIntent(ChangePasswordIntents intent) {
    switch (intent) {
      case CurrentPasswordChanged():
        emit(
          state.copyWith(
            currentPassword: intent.currentPassword,
            isvalidForm: _validate(currentPass: intent.currentPassword),
          ),
        );
        break;
      case NewPasswordChanged():
        emit(
          state.copyWith(
            newPassword: intent.newPassword,
            isvalidForm: _validate(newPass: intent.newPassword),
          ),
        );
        break;

      case ConfirmPasswordChanged():
        emit(
          state.copyWith(
            confirmPassword: intent.confirmPassword,
            isvalidForm: _validate(confirmPass: intent.confirmPassword),
          ),
        );
        break;
      case UpdateIntent():
        _updatePawssord();
    }
  }

  bool? _validate({
    String? currentPass,
    String? newPass,
    String? confirmPass,
  }) {
    final currentPassword = currentPass ?? state.currentPassword;
    final newPassword = newPass ?? state.newPassword;
    final confirmPassword = confirmPass ?? state.confirmPassword;

    final allFieldsFilled =
        currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty;

    final passwordsMatch = newPassword == confirmPassword;

    return allFieldsFilled && passwordsMatch;
  }

  Future<void> _updatePawssord() async {
    if (state.currentPassword.trim().isEmpty) {
      _streamController.add(
        ShowErrorIntent(message: UiConstants.pleaseEnterYourCurrentPassword),
      );
      return;
    }

    if (state.newPassword.trim().isEmpty) {
      _streamController.add(
        ShowErrorIntent(message: UiConstants.pleaseEnterYourNewPassword),
      );
      return;
    }

    if (state.confirmPassword.trim().isEmpty) {
      _streamController.add(
        ShowErrorIntent(message: UiConstants.pleaseEnterYourConfirmPassword),
      );
      return;
    }

    if (state.newPassword.trim() != state.confirmPassword.trim()) {
      _streamController.add(
        ShowErrorIntent(message: UiConstants.passwordsDoNotMatch),
      );
      return;
    }

    if (state.currentPassword.trim() == state.newPassword.trim()) {
      _streamController.add(
        ShowErrorIntent(message: UiConstants.newPasswordSameAsOld),
      );
      return;
    }

    _streamController.add(ShowLoadingIntent());

    final request = ChangePasswordRequestEntity(
      currentPassword: state.currentPassword.trim(),
      newPassword: state.newPassword.trim(),
      confirmNewPassword: state.confirmPassword.trim(),
    );

    final response = await _passwordUseCase(request);

    switch (response) {
      case SuccessResponse():
        _streamController.add(
          NavigateToEditProfileIntent(
            message: UiConstants.passwordUpdatedSuccessfully,
          ),
        );
        break;
      case ErrorResponse():
        _streamController.add(ShowErrorIntent(message: response.error.message));
        break;
    }
  }
}
