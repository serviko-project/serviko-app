import 'dart:io';

import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import 'package:serviko_app/features/provider/onboarding/data/models/category_model.dart';
import 'package:serviko_app/features/provider/onboarding/data/models/provider_profile_model.dart';

// Handles provider onboarding API calls
abstract class ProviderOnboardingRemoteDataSource {
  Future<ProviderProfileModel> submitApplication(Map<String, dynamic> data);
  Future<ProviderProfileModel> getMyProviderProfile();
  Future<ProviderDocumentModel> uploadDocument({
    required String documentType,
    required File file,
  });
  Future<void> deleteDocument(String documentId);
  Future<ProviderProfileModel> reapply(Map<String, dynamic> data);
  Future<List<CategoryModel>> getCategories();

  // Profile Management Editing
  Future<ProviderProfileModel> updateProviderDetails(Map<String, dynamic> data);
  Future<ProviderProfileModel> uploadBannerImage(File file);
  Future<ProviderProfileModel> deleteBannerImage();
}

class ProviderOnboardingRemoteDataSourceImpl
    implements ProviderOnboardingRemoteDataSource {
  final ApiClient _apiClient;

  ProviderOnboardingRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<ProviderProfileModel> submitApplication(
    Map<String, dynamic> data,
  ) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.post(
        '/api/v1/providers/apply',
        data: data,
      );
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderProfileModel> getMyProviderProfile() async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.get('/api/v1/providers/me');
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderDocumentModel> uploadDocument({
    required String documentType,
    required File file,
  }) async {
    try {
      await _apiClient.setFirebaseAuthToken();

      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'document_type': documentType,
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        '/api/v1/providers/documents/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return ProviderDocumentModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      await _apiClient.dio.delete('/api/v1/providers/documents/$documentId');
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderProfileModel> reapply(Map<String, dynamic> data) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.put(
        '/api/v1/providers/reapply',
        data: data,
      );
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.get(
        '/api/v1/categories',
        queryParameters: {'limit': 100, 'status': 'active'},
      );
      final items = response.data['data'] as List<dynamic>;
      return items
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderProfileModel> updateProviderDetails(
    Map<String, dynamic> data,
  ) async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.patch(
        '/api/v1/providers/me',
        data: data,
      );
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderProfileModel> uploadBannerImage(File file) async {
    try {
      await _apiClient.setFirebaseAuthToken();

      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        '/api/v1/providers/me/banner',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<ProviderProfileModel> deleteBannerImage() async {
    try {
      await _apiClient.setFirebaseAuthToken();
      final response = await _apiClient.dio.delete(
        '/api/v1/providers/me/banner',
      );
      return ProviderProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

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
