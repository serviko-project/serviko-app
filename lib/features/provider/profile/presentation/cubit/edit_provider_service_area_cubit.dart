import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/update_provider_details_usecase.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_state.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';

class EditProviderServiceAreaCubit extends Cubit<EditProviderServiceAreaState> {
  final UpdateProviderDetailsUseCase _updateProviderDetailsUseCase;
  final LocationService _locationService;

  EditProviderServiceAreaCubit({
    required UpdateProviderDetailsUseCase updateProviderDetailsUseCase,
    LocationService? locationService,
  }) : _updateProviderDetailsUseCase = updateProviderDetailsUseCase,
       _locationService = locationService ?? LocationService(),
       super(const EditProviderServiceAreaState());

  void init({double? latitude, double? longitude, double? coverageRadius}) {
    emit(
      state.copyWith(
        latitude: latitude,
        longitude: longitude,
        coverageRadius: coverageRadius ?? 15.0,
        status: EditProviderServiceAreaStatus.initial,
      ),
    );

    if (latitude != null && longitude != null) {
      _resolveAddress(latitude, longitude);
    }
  }

  void setCoverageRadius(double radius) {
    emit(state.copyWith(coverageRadius: radius));
  }

  Future<void> detectCurrentLocation() async {
    emit(state.copyWith(isLocationLoading: true));
    try {
      final position = await _locationService.getCurrentPosition();
      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      emit(
        state.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          resolvedAddress: address,
          isLocationLoading: false,
        ),
      );
    } on LocationServiceException catch (e) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          status: EditProviderServiceAreaStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          status: EditProviderServiceAreaStatus.error,
          errorMessage: 'Failed to detect location.',
        ),
      );
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    emit(state.copyWith(latitude: lat, longitude: lng));
    await _resolveAddress(lat, lng);
  }

  Future<void> _resolveAddress(double lat, double lng) async {
    try {
      final address = await _locationService.getAddressFromCoordinates(
        lat,
        lng,
      );
      emit(state.copyWith(resolvedAddress: address));
    } catch (_) {
      emit(state.copyWith(resolvedAddress: 'Unknown location'));
    }
  }

  Future<void> saveServiceArea() async {
    if (state.latitude == null || state.longitude == null) {
      emit(
        state.copyWith(
          status: EditProviderServiceAreaStatus.error,
          errorMessage: 'Please select a location on the map',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditProviderServiceAreaStatus.saving));

    final result = await _updateProviderDetailsUseCase(
      UpdateProviderDetailsParams(
        latitude: state.latitude,
        longitude: state.longitude,
        coverageRadiusKm: state.coverageRadius,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditProviderServiceAreaStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: EditProviderServiceAreaStatus.success)),
    );
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
