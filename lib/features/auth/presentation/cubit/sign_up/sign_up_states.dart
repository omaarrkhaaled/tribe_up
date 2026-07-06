import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_response/sign_up_response_entity.dart';

class SignUpStates extends BaseState<SignUpResponseEntity> {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isFormValid;
  final String userName;

  const SignUpStates({
    super.data,
    super.errorMessage,
    super.isLoading,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isFormValid = false,
    this.userName = '',
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    confirmPassword,
    isFormValid,
    userName,
    errorMessage,
    isLoading,
    data,
  ];

  SignUpStates copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isFormValid,
    String? userName,
    String? errorMessage,
    bool? isLoading,
    SignUpResponseEntity? data,
  }) {
    return SignUpStates(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}
