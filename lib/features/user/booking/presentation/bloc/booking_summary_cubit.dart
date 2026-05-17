import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import '../../domain/entities/booking_request_payload.dart';
import '../../domain/usecases/create_booking_usecase.dart';

// States
enum BookingSummaryStatus { idle, submitting, success, failure }

class BookingSummaryState extends Equatable {
  final BookingSummaryStatus status;
  final String? bookingId;
  final String? errorMessage;

  const BookingSummaryState({
    this.status = BookingSummaryStatus.idle,
    this.bookingId,
    this.errorMessage,
  });

  BookingSummaryState copyWith({
    BookingSummaryStatus? status,
    String? bookingId,
    String? errorMessage,
  }) {
    return BookingSummaryState(
      status: status ?? this.status,
      bookingId: bookingId ?? this.bookingId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookingId, errorMessage];
}

// Cubit
class BookingSummaryCubit extends Cubit<BookingSummaryState> {
  final CreateBookingUseCase _createBookingUseCase;

  BookingSummaryCubit({required CreateBookingUseCase createBookingUseCase})
    : _createBookingUseCase = createBookingUseCase,
      super(const BookingSummaryState());

  Future<void> submitBooking(BookingRequestPayload payload) async {
    emit(
      state.copyWith(
        status: BookingSummaryStatus.submitting,
        errorMessage: null,
      ),
    );

    final dateStr = DateFormat('yyyy-MM-dd').format(payload.selectedDate);

    final result = await _createBookingUseCase(
      CreateBookingParams(
        serviceId: payload.initData.serviceId,
        scheduledDate: dateStr,
        startTime: DateTimeUtils.formatTo24Hour(payload.selectedStartTime),
        durationHours: payload.workingHours,
        customerLatitude: payload.customerLatitude,
        customerLongitude: payload.customerLongitude,
        customerAddress: payload.customerAddress,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingSummaryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (booking) => emit(
        state.copyWith(
          status: BookingSummaryStatus.success,
          bookingId: booking.id,
        ),
      ),
    );
  }
}
