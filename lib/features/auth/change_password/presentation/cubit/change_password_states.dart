import 'package:tribe_up/config/base_state/base_state.dart';

class ChangePasswordStates extends BaseState<void> {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isvalidForm;

  const ChangePasswordStates({
    super.errorMessage,
    super.isLoading,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isvalidForm = false,
  });

  @override
  List<Object?> get props => [
    errorMessage,
    isLoading,
    currentPassword,
    newPassword,
    confirmPassword,
    isvalidForm,
  ];

  ChangePasswordStates copyWith({
    data,
    String? errorMessage,
    bool? isLoading,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isvalidForm,
  }) {
    return ChangePasswordStates(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isvalidForm: isvalidForm ?? this.isvalidForm,
    );
  }
}
