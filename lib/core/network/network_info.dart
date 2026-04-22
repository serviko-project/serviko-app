import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Abstraction for checking network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// NetworkInfo Implementation
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.connectionChecker);

  final InternetConnection connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
