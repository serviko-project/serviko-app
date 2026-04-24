part of 'sign_up_cubit.dart';

// Sign-up form state
class SignUpState extends Equatable {
  final bool agreeToTerms;
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  const SignUpState({
    this.agreeToTerms = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  SignUpState copyWith({
    bool? agreeToTerms,
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) => SignUpState(
    agreeToTerms: agreeToTerms ?? this.agreeToTerms,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    user: user,
  );

  @override
  List<Object?> get props => [agreeToTerms, isLoading, error, user];
}
