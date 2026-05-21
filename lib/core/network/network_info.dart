import 'package:connectivity_plus/connectivity_plus.dart';

// Abstraction for checking network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// NetworkInfo Implementation
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.connectivity);

  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
