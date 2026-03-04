import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_intents.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_states.dart';
import 'package:tribe_up/features/auth/login/presentation/cubit/login_ui_intents.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  final LoginUseCase _loginUseCase;
  final StreamController<LoginUiIntent> _uiIntentController =
      StreamController();

  Stream<LoginUiIntent> get uiIntents => _uiIntentController.stream;

  LoginCubit(this._loginUseCase) : super(LoginStates());

  void doIntent(LoginIntents intent) {
    switch (intent) {
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
      case LoginIntent():
        _login();
        break;
    }
  }

  bool _validate({String? email, String? password}) {
    return ((email ?? state.email).isNotEmpty &&
        (password ?? state.password).isNotEmpty);
  }

  void _login() async {
    _uiIntentController.add(ShowLoadingIntent());
    final request = LoginRequestEntity(
      email: state.email.trim(),
      password: state.password.trim(),
    );

    final response = await _loginUseCase(request);

    switch (response) {
      case SuccessResponse<LoginResponseEntity>():
        _uiIntentController.add(
          NavigateToFeedIntent(response.data.userSummary),
        );

        _uiIntentController.add(
          NavigateToFeedIntent(response.data.userSummary),
        );
        break;
      case ErrorResponse<LoginResponseEntity>():
        _uiIntentController.add(
          ShowErrorIntent(message: response.error.message),
        );
        break;
    }
  }
}
