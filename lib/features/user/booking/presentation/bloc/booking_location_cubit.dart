import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';

class BookingLocationState extends Equatable {
  final LatLng? currentLocation;
  final String? currentAddress;
  final bool isLoading;

  const BookingLocationState({
    this.currentLocation,
    this.currentAddress,
    this.isLoading = false,
  });

  BookingLocationState copyWith({
    LatLng? currentLocation,
    String? currentAddress,
    bool? isLoading,
  }) {
    return BookingLocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      currentAddress: currentAddress ?? this.currentAddress,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [currentLocation, currentAddress, isLoading];
}

class BookingLocationCubit extends Cubit<BookingLocationState> {
  final LocationService _locationService;

  BookingLocationCubit(this._locationService)
    : super(const BookingLocationState()) {
    _initLocation();
  }

  Future<void> recenter() => _initLocation();

  Future<void> _initLocation() async {
    emit(state.copyWith(isLoading: true));
    try {
      final position = await _locationService.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      final address = await _locationService.getAddressFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      emit(
        state.copyWith(
          currentLocation: latLng,
          currentAddress: address,
          isLoading: false,
        ),
      );
    } catch (e) {
      final latLng = const LatLng(11.050976, 76.071083);
      emit(
        state.copyWith(
          currentLocation: latLng,
          currentAddress: 'Malappuram, Kerala, India',
          isLoading: false,
        ),
      );
    }
  }

  Future<void> updateLocation(LatLng location) async {
    emit(state.copyWith(currentLocation: location, isLoading: true));
    try {
      final address = await _locationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );
      emit(state.copyWith(currentAddress: address, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(currentAddress: 'Unknown location', isLoading: false),
      );
    }
  }
}
