import 'package:equatable/equatable.dart';
import '../../../../user/booking/domain/entities/booking_entity.dart';

abstract class ProviderJobsState extends Equatable {
  final List<BookingEntity>? bookings;

  const ProviderJobsState({this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class ProviderJobsInitial extends ProviderJobsState {
  const ProviderJobsInitial() : super(bookings: const []);
}

class ProviderJobsLoading extends ProviderJobsState {
  const ProviderJobsLoading({super.bookings = const []});
}

class ProviderJobsLoaded extends ProviderJobsState {
  final bool hasReachedMax;

  const ProviderJobsLoaded({
    required super.bookings,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [bookings, hasReachedMax];
}

class ProviderJobsError extends ProviderJobsState {
  final String message;

  const ProviderJobsError(this.message, {super.bookings});

  @override
  List<Object?> get props => [message, bookings];
}

class ProviderJobUpdating extends ProviderJobsState {
  final String bookingId;

  const ProviderJobUpdating(this.bookingId, List<BookingEntity> bookings)
    : super(bookings: bookings);

  @override
  List<Object?> get props => [bookingId, bookings];
}

class ProviderJobUpdated extends ProviderJobsState {
  final BookingEntity booking;

  const ProviderJobUpdated(this.booking, List<BookingEntity> bookings)
    : super(bookings: bookings);

  @override
  List<Object?> get props => [booking, bookings];
}
