import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/application_status_state.dart';

// Manages application status screen data
class ApplicationStatusCubit extends Cubit<ApplicationStatusState> {
  final GetMyProviderProfileUseCase _getMyProviderProfileUseCase;

  ApplicationStatusCubit({
    required GetMyProviderProfileUseCase getMyProviderProfileUseCase,
  }) : _getMyProviderProfileUseCase = getMyProviderProfileUseCase,
       super(const ApplicationStatusState());

  Future<void> loadStatus() async {
    emit(state.copyWith(isLoading: true));

    final result = await _getMyProviderProfileUseCase(const NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (profile) =>
          emit(state.copyWith(isLoading: false, providerProfile: profile)),
    );
  }
}
