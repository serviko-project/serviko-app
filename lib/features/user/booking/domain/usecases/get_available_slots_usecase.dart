import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../entities/available_slots_entity.dart';
import '../repositories/booking_repository.dart';

class GetAvailableSlotsUseCase
    implements UseCase<AvailableSlotsEntity, GetAvailableSlotsParams> {
  final BookingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, AvailableSlotsEntity>> call(
    GetAvailableSlotsParams params,
  ) async {
    return await repository.getAvailableSlots(
      providerId: params.providerId,
      date: params.date,
      durationHours: params.durationHours,
    );
  }
}

class GetAvailableSlotsParams extends Equatable {
  final String providerId;
  final String date;
  final int durationHours;

  const GetAvailableSlotsParams({
    required this.providerId,
    required this.date,
    required this.durationHours,
  });

  @override
  List<Object?> get props => [providerId, date, durationHours];
}
