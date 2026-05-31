import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:serviko_app/core/errors/exceptions.dart';

// Centralized Dio HTTP client configuration.
class ApiClient {
  // Emulator
  static const String _baseUrl = 'https://serviko-backend-3ai7.onrender.com';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Enable logging interceptor in debug mode only
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  // Fetch a fresh Firebase ID token and set it as the auth header.
  Future<void> setFirebaseAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        setAuthToken(token);
      }
    }
  }

  // Attach auth token to every request
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove the auth token (Logout).
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  // Helper method to handle API requests with error handling and response parsing
  Future<T> request<T>({
    required Future<Response> Function() call,
    required T Function(dynamic data) parser,
    bool requiresAuth = true,
  }) async {
    try {
      if (requiresAuth) {
        await setFirebaseAuthToken();
      }

      final response = await call();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return parser(data['data']);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['detail'] ??
          e.message ??
          'Unknown error';
      throw ServerException(message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
