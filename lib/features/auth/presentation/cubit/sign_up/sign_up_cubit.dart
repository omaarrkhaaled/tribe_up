import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_response/sign_up_response_entity.dart';
import 'package:tribe_up/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_intents.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_states.dart';
import 'package:tribe_up/features/auth/presentation/cubit/sign_up/sign_up_ui_intents.dart';

@injectable
class SignUpCubit extends Cubit<SignUpStates> {
  final SignUpUseCase _signUpUseCase;
  final StreamController<SignUpUiIntent> _uiIntentController =
      StreamController();

  Stream<SignUpUiIntent> get uiIntents => _uiIntentController.stream;

  SignUpCubit(this._signUpUseCase) : super(SignUpStates());

  void doIntent(SignUpIntents intent) {
    switch (intent) {
      case FirstNameChanged():
        emit(
          state.copyWith(
            firstName: intent.firstName,
            isFormValid: _validate(firstName: intent.firstName),
          ),
        );
        break;
      case LastNameChanged():
        emit(
          state.copyWith(
            lastName: intent.lastName,
            isFormValid: _validate(lastName: intent.lastName),
          ),
        );
        break;
      case EmailChanged():
        emit(
          state.copyWith(
            email: intent.email,
            isFormValid: _validate(email: intent.email),
          ),
        );
        break;
      case PasswordChanged():
        emit(
          state.copyWith(
            password: intent.password,
            isFormValid: _validate(password: intent.password),
          ),
        );
        break;
      case ConfirmPasswordChanged():
        emit(
          state.copyWith(
            confirmPassword: intent.confirmPassword,
            isFormValid: _validate(confirmPassword: intent.confirmPassword),
          ),
        );
        break;
      case UserNameChanged():
        emit(
          state.copyWith(
            userName: intent.userName,
            isFormValid: _validate(userName: intent.userName),
          ),
        );
        break;
      case SignUpIntent():
        _register();
        break;
    }
  }

  bool _validate({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? userName,
  }) {
    return (firstName ?? state.firstName).isNotEmpty &&
        (lastName ?? state.lastName).isNotEmpty &&
        (email ?? state.email).isNotEmpty &&
        (password ?? state.password).isNotEmpty &&
        (confirmPassword ?? state.confirmPassword).isNotEmpty &&
        (userName ?? state.userName).isNotEmpty;
  }

  Future<void> _register() async {
    _uiIntentController.add(ShowLoadingIntent());

    final request = SignUpRequestEntity(
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      email: state.email.trim(),
      password: state.password.trim(),
      confirmPassword: state.confirmPassword.trim(),
      userName: state.userName.trim(),
    );

    final response = await _signUpUseCase(request);

    switch (response) {
      case SuccessResponse<SignUpResponseEntity>():
        _uiIntentController.add(
          NavigateToLoginIntent(
            message: UiConstants.yourAccountHasBeenCreatedSuccessfully,
          ),
        );
        break;
      case ErrorResponse<SignUpResponseEntity>():
        _uiIntentController.add(
          ShowErrorIntent(message: response.error.message),
        );
        break;
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
