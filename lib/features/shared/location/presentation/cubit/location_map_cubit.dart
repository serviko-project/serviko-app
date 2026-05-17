import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationMapCubit extends Cubit<LatLng> {
  LocationMapCubit(super.initialPin);

  void updatePin(LatLng newPin) => emit(newPin);
}
