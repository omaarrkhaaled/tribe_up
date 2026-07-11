import 'package:tribe_up/config/base_state/base_state.dart';

class LogoutStates extends BaseState<void> {
  const LogoutStates({super.isLoading, super.errorMessage});

  @override
  List<Object?> get props => [isLoading, errorMessage];

  LogoutStates copyWith({bool? isLoading, String? errorMessage}) {
    return LogoutStates(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
