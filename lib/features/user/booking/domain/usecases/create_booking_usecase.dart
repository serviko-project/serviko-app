import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase
    implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
    CreateBookingParams params,
  ) async {
    return await repository.createBooking(
      serviceId: params.serviceId,
      scheduledDate: params.scheduledDate,
      startTime: params.startTime,
      durationHours: params.durationHours,
      customerLatitude: params.customerLatitude,
      customerLongitude: params.customerLongitude,
      customerAddress: params.customerAddress,
    );
  }
}

class CreateBookingParams extends Equatable {
  final String serviceId;
  final String scheduledDate;
  final String startTime;
  final int durationHours;
  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerAddress;

  const CreateBookingParams({
    required this.serviceId,
    required this.scheduledDate,
    required this.startTime,
    required this.durationHours,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAddress,
  });

  @override
  List<Object?> get props => [
    serviceId,
    scheduledDate,
    startTime,
    durationHours,
    customerLatitude,
    customerLongitude,
    customerAddress,
  ];
}
