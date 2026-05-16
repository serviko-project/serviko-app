import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

abstract class MyBookingsState extends Equatable {
  const MyBookingsState();

  @override
  List<Object?> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingEntity> upcomingBookings;
  final List<BookingEntity> completedBookings;
  final List<BookingEntity> cancelledBookings;

  const MyBookingsLoaded({
    required this.upcomingBookings,
    required this.completedBookings,
    required this.cancelledBookings,
  });

  @override
  List<Object?> get props => [
    upcomingBookings,
    completedBookings,
    cancelledBookings,
  ];
}

class MyBookingsError extends MyBookingsState {
  final String message;

  const MyBookingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
