import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit_base.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';

mixin OnboardingLocationMixin on ProviderOnboardingCubitBase {
  @override
  LocationService get locationService;

  void setCoverageRadius(double radius) =>
      emit(state.copyWith(coverageRadius: radius));

  // Detect current GPS location
  Future<void> detectCurrentLocation() async {
    emit(state.copyWith(isLocationLoading: true));
    try {
      final position = await locationService.getCurrentPosition();
      final address = await locationService.getAddressFromCoordinates(
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
      emit(state.copyWith(isLocationLoading: false, errorMessage: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          errorMessage: 'Failed to detect location.',
        ),
      );
    }
  }

  // Update location when user drags pin on map
  Future<void> updateLocation(double lat, double lng) async {
    emit(state.copyWith(latitude: lat, longitude: lng));
    try {
      final address = await locationService.getAddressFromCoordinates(lat, lng);
      emit(state.copyWith(resolvedAddress: address));
    } catch (_) {
      emit(state.copyWith(resolvedAddress: 'Unknown location'));
    }
  }
}
