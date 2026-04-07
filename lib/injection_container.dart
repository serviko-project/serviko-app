import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/core/network/network_info.dart';

class InjectionContainer {
  InjectionContainer._();

  static final InjectionContainer _instance = InjectionContainer._();
  static InjectionContainer get instance => _instance;

  // Core
  late final ApiClient apiClient;
  late final NetworkInfo networkInfo;

  // Initialise
  Future<void> init() async {
    // Core
    apiClient = ApiClient();
    networkInfo = NetworkInfoImpl(InternetConnection());
  }
}
