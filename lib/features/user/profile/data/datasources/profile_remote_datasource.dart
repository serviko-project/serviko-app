import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/user/profile/data/models/profile_model.dart';

// Handles profile-related API calls
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> createProfile(Map<String, dynamic> data);
  Future<UserProfileModel> getMyProfile();
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  // Create a new Profile
  @override
  Future<UserProfileModel> createProfile(Map<String, dynamic> data) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.post('/api/v1/users', data: data);
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // Get the current user's Profile
  @override
  Future<UserProfileModel> getMyProfile() async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.get('/api/v1/users/me');
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // Update the current user's Profile
  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.patch(
        '/api/v1/users/me',
        data: data,
      );
      return UserProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // Convert DioException to a more user-friendly msg
  ServerException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message = 'Something went wrong. Please try again.';

    if (data is Map<String, dynamic>) {
      message = data['detail'] as String? ?? message;
    }

    return ServerException(message, statusCode: statusCode);
  }
}
