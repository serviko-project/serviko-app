import 'package:equatable/equatable.dart';
import '../../../../user/booking/domain/entities/booking_entity.dart';

abstract class ProviderJobsState extends Equatable {
  const ProviderJobsState();

  @override
  List<Object?> get props => [];
}

class ProviderJobsInitial extends ProviderJobsState {}

class ProviderJobsLoading extends ProviderJobsState {
  final List<BookingEntity> bookings;

  const ProviderJobsLoading({this.bookings = const []});

  @override
  List<Object?> get props => [bookings];
}

class ProviderJobsLoaded extends ProviderJobsState {
  final List<BookingEntity> bookings;
  final bool hasReachedMax;

  const ProviderJobsLoaded({
    required this.bookings,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [bookings, hasReachedMax];
}

class ProviderJobsError extends ProviderJobsState {
  final String message;
  final List<BookingEntity>? bookings;

  const ProviderJobsError(this.message, {this.bookings});

  @override
  List<Object?> get props => [message, bookings];
}

class ProviderJobUpdating extends ProviderJobsState {
  final String bookingId;
  final List<BookingEntity> bookings;

  const ProviderJobUpdating(this.bookingId, this.bookings);

  @override
  List<Object?> get props => [bookingId, bookings];
}

class ProviderJobUpdated extends ProviderJobsState {
  final BookingEntity booking;
  final List<BookingEntity> bookings;

  const ProviderJobUpdated(this.booking, this.bookings);

  @override
  List<Object?> get props => [booking, bookings];
}
