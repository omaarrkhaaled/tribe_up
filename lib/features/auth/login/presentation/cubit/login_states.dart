import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';

class LoginStates extends BaseState<LoginResponseEntity> {
  final String email;
  final String password;
  final bool isFormValid;

  const LoginStates({
    super.data,
    super.errorMessage,
    super.isLoading,
   this.email = '',
   this.password = '',
   this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        isFormValid,
        errorMessage,
        isLoading,
        data,
      ];

  LoginStates copyWith({
    String? email,
    String? password,
    bool? isFormValid,
    String? errorMessage,
    bool? isLoading,
    LoginResponseEntity? data,
  }) {
    return LoginStates(
      email: email ?? this.email,
      password: password ?? this.password,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}