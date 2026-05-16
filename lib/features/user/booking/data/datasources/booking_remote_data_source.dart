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
  }) {
    return apiClient.request(
      call: () => apiClient.dio.get(
        '/api/v1/bookings/availability',
        queryParameters: {
          'provider_id': providerId,
          'date': date,
          'duration_hours': durationHours,
        },
      ),
      parser: (data) =>
          AvailableSlotsModel.fromJson(data as Map<String, dynamic>),
    );
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
  }) {
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

    return apiClient.request(
      call: () => apiClient.dio.post('/api/v1/bookings', data: body),
      parser: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<List<BookingModel>> getProviderBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) queryParams['status'] = status;

    return apiClient.request(
      call: () => apiClient.dio.get(
        '/api/v1/bookings/provider',
        queryParameters: queryParams,
      ),
      parser: (data) {
        final List list = data as List;
        return list.map((e) => BookingModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<BookingModel> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.patch(
        '/api/v1/bookings/$bookingId/review',
        data: {'action': action, 'rejection_reason': rejectionReason},
      ),
      parser: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BookingModel> getBookingDetail({required String bookingId}) {
    return apiClient.request(
      call: () => apiClient.dio.get('/api/v1/bookings/$bookingId'),
      parser: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BookingModel> cancelBooking({required String bookingId}) {
    return apiClient.request(
      call: () => apiClient.dio.patch('/api/v1/bookings/$bookingId/cancel'),
      parser: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<List<BookingModel>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) queryParams['status'] = status;

    return apiClient.request(
      call: () =>
          apiClient.dio.get('/api/v1/bookings', queryParameters: queryParams),
      parser: (data) {
        final List list = data as List;
        return list.map((e) => BookingModel.fromJson(e)).toList();
      },
    );
  }
}
