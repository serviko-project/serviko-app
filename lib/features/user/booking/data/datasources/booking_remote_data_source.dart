import 'package:dio/dio.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/network/api_client.dart';
import '../models/available_slots_model.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<AvailableSlotsModel> getAvailableSlots({
    required String providerId,
    required String date,
    required int durationHours,
  });

  Future<BookingModel> createBooking({
    required String serviceId,
    required String scheduledDate,
    required String startTime,
    required int durationHours,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  });

  Future<List<BookingModel>> getProviderBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<BookingModel> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  });

  Future<BookingModel> getBookingDetail({required String bookingId});

  Future<BookingModel> cancelBooking({required String bookingId});

  Future<List<BookingModel>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AvailableSlotsModel> getAvailableSlots({
    required String providerId,
    required String date,
    required int durationHours,
  }) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.get(
        '/api/v1/bookings/availability',
        queryParameters: {
          'provider_id': providerId,
          'date': date,
          'duration_hours': durationHours,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return AvailableSlotsModel.fromJson(
            data['data'] as Map<String, dynamic>,
          );
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load available slots');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookingModel> createBooking({
    required String serviceId,
    required String scheduledDate,
    required String startTime,
    required int durationHours,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) async {
    try {
      await apiClient.setFirebaseAuthToken();

      final Map<String, dynamic> body = {
        'service_id': serviceId,
        'scheduled_date': scheduledDate,
        'start_time': startTime,
        'duration_hours': durationHours,
      };

      if (customerLatitude != null && customerLongitude != null) {
        body['customer_latitude'] = customerLatitude;
        body['customer_longitude'] = customerLongitude;
      }
      if (customerAddress != null) {
        body['customer_address'] = customerAddress;
      }

      final response = await apiClient.dio.post('/api/v1/bookings', data: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return BookingModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to create booking');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getProviderBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) queryParams['status'] = status;

      final response = await apiClient.dio.get(
        '/api/v1/bookings/provider',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List list = data['data'];
          return list.map((e) => BookingModel.fromJson(e)).toList();
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load provider bookings');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookingModel> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  }) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.patch(
        '/api/v1/bookings/$bookingId/review',
        data: {'action': action, 'rejection_reason': rejectionReason},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return BookingModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to review booking');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookingModel> getBookingDetail({required String bookingId}) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.get('/api/v1/bookings/$bookingId');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return BookingModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to fetch booking details');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookingModel> cancelBooking({required String bookingId}) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final response = await apiClient.dio.patch(
        '/api/v1/bookings/$bookingId/cancel',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return BookingModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to cancel booking');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await apiClient.setFirebaseAuthToken();
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) queryParams['status'] = status;

      final response = await apiClient.dio.get(
        '/api/v1/bookings',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List list = data['data'];
          return list.map((e) => BookingModel.fromJson(e)).toList();
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException('Failed to load customer bookings');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['detail'] ?? e.message ?? 'Unknown error',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
