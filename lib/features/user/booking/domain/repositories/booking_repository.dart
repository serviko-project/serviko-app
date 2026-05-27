import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/available_slots_entity.dart';
import '../entities/booking_entity.dart';
import '../entities/review_entity.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

abstract class BookingRepository {
  Future<Either<Failure, AvailableSlotsEntity>> getAvailableSlots({
    required String providerId,
    required String date,
    required int durationHours,
  });

  Future<Either<Failure, BookingEntity>> createBooking({
    required String serviceId,
    required String scheduledDate,
    required String startTime,
    required int durationHours,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
    String? promoCode,
  });

  Future<Either<Failure, Map<String, dynamic>>> validatePromoCode({
    required String code,
    required String serviceId,
  });

  Future<Either<Failure, List<PromoCode>>> getProviderPromos({
    required String providerId,
  });

  Future<Either<Failure, List<PromoCode>>> getActivePromoCodes({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, List<BookingEntity>>> getProviderBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, BookingEntity>> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  });

  Future<Either<Failure, BookingEntity>> getBookingDetail({
    required String bookingId,
  });

  Future<Either<Failure, BookingEntity>> cancelBooking({
    required String bookingId,
  });

  Future<Either<Failure, BookingEntity>> completeBooking({
    required String bookingId,
    String? completionNote,
  });

  Future<Either<Failure, List<BookingEntity>>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, List<ReviewEntity>>> getProviderReviews({
    required String providerId,
    int? rating,
    int page = 1,
    int limit = 20,
  });
}
