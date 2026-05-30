import 'package:serviko_app/core/network/api_client.dart';
import '../models/available_slots_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';

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
    String? promoCode,
  });

  Future<Map<String, dynamic>> validatePromoCode({
    required String code,
    required String serviceId,
  });

  Future<List<Map<String, dynamic>>> getProviderPromos({
    required String providerId,
  });

  Future<List<Map<String, dynamic>>> getActivePromoCodes({
    int page = 1,
    int limit = 20,
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

  Future<BookingModel> completeBooking({
    required String bookingId,
    String? completionNote,
  });

  Future<List<BookingModel>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<ReviewModel> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });

  Future<List<ReviewModel>> getProviderReviews({
    required String providerId,
    int? rating,
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> getProviderReviewStats({
    required String providerId,
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
    String? promoCode,
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
    if (promoCode != null && promoCode.trim().isNotEmpty) {
      body['promo_code'] = promoCode;
    }

    return apiClient.request(
      call: () => apiClient.dio.post('/api/v1/bookings', data: body),
      parser: (data) => BookingModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Map<String, dynamic>> validatePromoCode({
    required String code,
    required String serviceId,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.post(
        '/api/v1/promo-codes/validate',
        data: {'code': code, 'service_id': serviceId},
      ),
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getProviderPromos({
    required String providerId,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.get(
        '/api/v1/promo-codes',
        queryParameters: {'provider_id': providerId},
      ),
      parser: (data) {
        final List list = data as List;
        return list.cast<Map<String, dynamic>>();
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getActivePromoCodes({
    int page = 1,
    int limit = 20,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.get(
        '/api/v1/promo-codes/active',
        queryParameters: {'page': page, 'limit': limit},
      ),
      parser: (data) {
        final List list = data as List;
        return list.cast<Map<String, dynamic>>();
      },
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
  Future<BookingModel> completeBooking({
    required String bookingId,
    String? completionNote,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.patch(
        '/api/v1/bookings/$bookingId/complete',
        data: {'completion_note': completionNote},
      ),
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

  @override
  Future<ReviewModel> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.post(
        '/api/v1/reviews',
        data: {'booking_id': bookingId, 'rating': rating, 'comment': comment},
      ),
      parser: (data) => ReviewModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<List<ReviewModel>> getProviderReviews({
    required String providerId,
    int? rating,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = <String, dynamic>{
      'provider_id': providerId,
      'page': page,
      'limit': limit,
    };
    if (rating != null) {
      queryParams['rating'] = rating;
    }

    return apiClient.request(
      call: () =>
          apiClient.dio.get('/api/v1/reviews', queryParameters: queryParams),
      parser: (data) {
        final List list = data as List;
        return list.map((e) => ReviewModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getProviderReviewStats({
    required String providerId,
  }) {
    return apiClient.request(
      call: () => apiClient.dio.get(
        '/api/v1/reviews/stats',
        queryParameters: {'provider_id': providerId},
      ),
      parser: (data) => data as Map<String, dynamic>,
    );
  }
}
