part of 'create_new_password_cubit.dart';

// Create new password form state
class CreateNewPasswordState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const CreateNewPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  CreateNewPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) => CreateNewPasswordState(
    isLoading: isLoading ?? this.isLoading,
    isSuccess: isSuccess ?? this.isSuccess,
    error: error,
  );

  @override
  List<Object?> get props => [isLoading, isSuccess, error];
}
