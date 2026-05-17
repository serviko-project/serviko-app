import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/customer_address_state.dart';

class CustomerAddressCubit extends Cubit<CustomerAddressState> {
  final LocationService _locationService;
  final UpdateProfileUseCase _updateProfileUseCase;

  CustomerAddressCubit({
    required LocationService locationService,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _locationService = locationService,
       _updateProfileUseCase = updateProfileUseCase,
       super(const CustomerAddressState());

  Future<void> detectCurrentLocation() async {
    emit(state.copyWith(status: CustomerAddressStatus.locLoading));

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            status: CustomerAddressStatus.error,
            errorMessage: 'Location services are disabled.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              status: CustomerAddressStatus.error,
              errorMessage: 'Location permissions are denied.',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: CustomerAddressStatus.error,
            errorMessage: 'Location permissions are permanently denied.',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await updateLocation(position.latitude, position.longitude);
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerAddressStatus.error,
          errorMessage: 'Failed to get current location: $e',
        ),
      );
    }
  }

  Future<void> updateLocation(double lat, double lng) async {
    emit(
      state.copyWith(
        status: CustomerAddressStatus.locLoading,
        latitude: lat,
        longitude: lng,
        resolvedAddress: 'Resolving address...',
      ),
    );

    try {
      final address = await _locationService.getAddressFromCoordinates(
        lat,
        lng,
      );
      emit(
        state.copyWith(
          status: CustomerAddressStatus.initial,
          resolvedAddress: address,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerAddressStatus.error,
          resolvedAddress: 'Location selected',
        ),
      );
    }
  }

  Future<void> submitAddress() async {
    if (state.latitude == null || state.longitude == null) {
      emit(
        state.copyWith(
          status: CustomerAddressStatus.error,
          errorMessage: 'Please select a location on the map.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CustomerAddressStatus.submitting));

    final result = await _updateProfileUseCase(
      UpdateProfileParams(latitude: state.latitude, longitude: state.longitude),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CustomerAddressStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: CustomerAddressStatus.success));
      },
    );
  }
}
