import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

enum ViewBookingStatus { initial, loading, loaded, error }

enum ViewBookingActionStatus { none, loading, success, error }

class ViewBookingState extends Equatable {
  final ViewBookingStatus status;
  final ViewBookingActionStatus actionStatus;
  final BookingEntity? booking;
  final String? message;

  const ViewBookingState({
    this.status = ViewBookingStatus.initial,
    this.actionStatus = ViewBookingActionStatus.none,
    this.booking,
    this.message,
  });

  ViewBookingState copyWith({
    ViewBookingStatus? status,
    ViewBookingActionStatus? actionStatus,
    BookingEntity? booking,
    String? message,
  }) {
    return ViewBookingState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      booking: booking ?? this.booking,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, actionStatus, booking, message];
}
