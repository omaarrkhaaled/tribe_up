import 'package:equatable/equatable.dart';

class CreateTribeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const CreateTribeState({this.isLoading = false, this.errorMessage});

  CreateTribeState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateTribeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
