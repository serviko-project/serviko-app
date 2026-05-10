import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_my_provider_profile_usecase.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_state.dart';

class ProviderProfileCubit extends Cubit<ProviderProfileState> {
  final GetMyProviderProfileUseCase _getMyProviderProfileUseCase;

  ProviderProfileCubit({
    required GetMyProviderProfileUseCase getMyProviderProfileUseCase,
  }) : _getMyProviderProfileUseCase = getMyProviderProfileUseCase,
       super(ProviderProfileInitial());

  Future<void> fetchProviderProfile() async {
    emit(ProviderProfileLoading());
    final result = await _getMyProviderProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(ProviderProfileError(failure.message)),
      (profile) => emit(ProviderProfileLoaded(profile)),
    );
  }
}
