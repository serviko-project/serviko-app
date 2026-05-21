import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/network/network_info.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize core dependencies
extension CoreDI on InjectionContainer {
  void initCore() {
    apiClient = ApiClient();
    networkInfo = NetworkInfoImpl(Connectivity());
    locationService = LocationService();
  }
}
