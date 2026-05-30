import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/exceptions.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/network/network_info.dart';

import '../../domain/entities/available_slots_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import 'package:serviko_app/features/provider/promo_codes/data/models/promo_code_model.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

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
    String? promoCode,
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
        promoCode: promoCode,
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
  Future<Either<Failure, Map<String, dynamic>>> validatePromoCode({
    required String code,
    required String serviceId,
  }) async {
    try {
      final remoteData = await remoteDataSource.validatePromoCode(
        code: code,
        serviceId: serviceId,
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
  Future<Either<Failure, List<PromoCode>>> getProviderPromos({
    required String providerId,
  }) async {
    try {
      final remoteData = await remoteDataSource.getProviderPromos(
        providerId: providerId,
      );
      final promos = remoteData
          .map((json) => PromoCodeModel.fromJson(json))
          .toList();
      return Right(promos);
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
  Future<Either<Failure, List<PromoCode>>> getActivePromoCodes({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteData = await remoteDataSource.getActivePromoCodes(
        page: page,
        limit: limit,
      );
      final promos = remoteData
          .map((json) => PromoCodeModel.fromJson(json))
          .toList();
      return Right(promos);
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
  Future<Either<Failure, BookingEntity>> completeBooking({
    required String bookingId,
    String? completionNote,
  }) async {
    try {
      final remoteData = await remoteDataSource.completeBooking(
        bookingId: bookingId,
        completionNote: completionNote,
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

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      final remoteData = await remoteDataSource.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
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
  Future<Either<Failure, List<ReviewEntity>>> getProviderReviews({
    required String providerId,
    int? rating,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final remoteData = await remoteDataSource.getProviderReviews(
        providerId: providerId,
        rating: rating,
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
  Future<Either<Failure, Map<String, dynamic>>> getProviderReviewStats({
    required String providerId,
  }) async {
    try {
      final remoteData = await remoteDataSource.getProviderReviewStats(
        providerId: providerId,
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
