import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/logout/domain/use_case/logout_use_case.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_intents.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_states.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_ui_intents.dart';

@injectable
class LogoutCubit extends Cubit<LogoutStates> {
  final LogoutUseCase _logoutUseCase;
  final StreamController<LogoutUiIntents> _uiIntentController =
      StreamController();

  Stream<LogoutUiIntents> get uiIntents => _uiIntentController.stream;

  LogoutCubit(this._logoutUseCase) : super(const LogoutStates());

  void doIntent(LogoutIntents intent) {
    switch (intent) {
      case LogoutIntent():
        _logout();
        break;
    }
  }

  void _logout() async {
    _uiIntentController.add(ShowLoadingIntents());
    final response = await _logoutUseCase();
    switch (response) {
      case SuccessResponse():
        _uiIntentController.add(NavigateToLoginIntent());
        break;
      case ErrorResponse():
        _uiIntentController.add(ShowErrorIntents(response.error.message));
        break;
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}
