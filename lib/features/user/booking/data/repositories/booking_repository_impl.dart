import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';

import '../../domain/entities/available_slots_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AvailableSlotsEntity>> getAvailableSlots({
    required String providerId,
    required String date,
    required int durationHours,
  }) async {
    try {
      final remoteData = await remoteDataSource.getAvailableSlots(
        providerId: providerId,
        date: date,
        durationHours: durationHours,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required String serviceId,
    required String scheduledDate,
    required String startTime,
    required int durationHours,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) async {
    try {
      final remoteData = await remoteDataSource.createBooking(
        serviceId: serviceId,
        scheduledDate: scheduledDate,
        startTime: startTime,
        durationHours: durationHours,
        customerLatitude: customerLatitude,
        customerLongitude: customerLongitude,
        customerAddress: customerAddress,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getProviderBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteData = await remoteDataSource.getProviderBookings(
        status: status,
        page: page,
        limit: limit,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  }) async {
    try {
      final remoteData = await remoteDataSource.reviewBooking(
        bookingId: bookingId,
        action: action,
        rejectionReason: rejectionReason,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingDetail({
    required String bookingId,
  }) async {
    try {
      final remoteData = await remoteDataSource.getBookingDetail(
        bookingId: bookingId,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking({
    required String bookingId,
  }) async {
    try {
      final remoteData = await remoteDataSource.cancelBooking(
        bookingId: bookingId,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getCustomerBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteData = await remoteDataSource.getCustomerBookings(
        status: status,
        page: page,
        limit: limit,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
