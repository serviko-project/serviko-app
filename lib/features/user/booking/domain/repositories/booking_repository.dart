import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import '../entities/available_slots_entity.dart';
import '../entities/booking_entity.dart';

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

  Future<Either<Failure, List<BookingEntity>>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  });
}
