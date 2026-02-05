import 'package:tribe_up/config/base_state/base_state.dart';

class ForgetPasswordStates extends BaseState {
  final String email;
  final bool isValidForm;

  const ForgetPasswordStates({
    super.errorMessage,
    super.isLoading,
    this.email = '',
    this.isValidForm = false,
  });

  @override
  List<Object?> get props => [
    errorMessage,
    isLoading,
    email,
    isValidForm,
  ];

  ForgetPasswordStates copyWith({
    String? errorMessage,
    bool? isLoading,
    String? email,
    bool? isValidForm,
  }) {
    return ForgetPasswordStates(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      isValidForm: isValidForm ?? this.isValidForm,
    );
  }
}
