import 'package:dio/dio.dart';

// Centralized Dio HTTP client configuration.
class ApiClient {
  static const String _baseUrl = 'https://api.serviko.com/v1';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }
  // Attach an auth token to every outgoing request.
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove the auth token (Logout).
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
