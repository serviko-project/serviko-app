import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/support/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/privacy_policy_state.dart';

// Cubit to manage Privacy Policy state
class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  final GetPrivacyPolicyUseCase _getPrivacyPolicyUseCase;

  PrivacyPolicyCubit({required GetPrivacyPolicyUseCase getPrivacyPolicyUseCase})
    : _getPrivacyPolicyUseCase = getPrivacyPolicyUseCase,
      super(const PrivacyPolicyInitial());

  Future<void> loadPrivacyPolicy() async {
    emit(const PrivacyPolicyLoading());

    final result = await _getPrivacyPolicyUseCase(const NoParams());

    result.fold(
      (failure) => emit(PrivacyPolicyError(failure.message)),
      (policy) => emit(PrivacyPolicyLoaded(policy)),
    );
  }
}
