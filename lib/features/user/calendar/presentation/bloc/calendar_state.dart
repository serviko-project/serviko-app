import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final Map<DateTime, List<BookingEntity>> bookingsByDate;
  final DateTime selectedDate;
  final List<BookingEntity> selectedDateBookings;

  const CalendarLoaded({
    required this.bookingsByDate,
    required this.selectedDate,
    required this.selectedDateBookings,
  });

  @override
  List<Object?> get props => [
    bookingsByDate,
    selectedDate,
    selectedDateBookings,
  ];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError({required this.message});

  @override
  List<Object?> get props => [message];
}
