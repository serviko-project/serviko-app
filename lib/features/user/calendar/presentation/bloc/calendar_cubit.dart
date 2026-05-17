import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_customer_bookings_usecase.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final GetCustomerBookingsUseCase getCustomerBookingsUseCase;
  Map<DateTime, List<BookingEntity>> _allBookingsByDate = {};
  DateTime _currentSelectedDate = DateTime.now();

  CalendarCubit({required this.getCustomerBookingsUseCase})
    : super(CalendarInitial());

  Future<void> fetchBookings() async {
    emit(CalendarLoading());

    final result = await getCustomerBookingsUseCase(
      const GetCustomerBookingsParams(limit: 50),
    );

    result.fold((failure) => emit(CalendarError(message: failure.message)), (
      bookings,
    ) {
      _allBookingsByDate = _groupBookingsByDate(bookings);
      _emitLoadedState();
    });
  }

  void selectDate(DateTime date) {
    _currentSelectedDate = date;
    if (state is CalendarLoaded) {
      _emitLoadedState();
    }
  }

  void _emitLoadedState() {
    final normalizedDate = DateTime(
      _currentSelectedDate.year,
      _currentSelectedDate.month,
      _currentSelectedDate.day,
    );

    final selectedBookings = _allBookingsByDate[normalizedDate] ?? [];

    emit(
      CalendarLoaded(
        bookingsByDate: _allBookingsByDate,
        selectedDate: _currentSelectedDate,
        selectedDateBookings: selectedBookings,
      ),
    );
  }

  Map<DateTime, List<BookingEntity>> _groupBookingsByDate(
    List<BookingEntity> bookings,
  ) {
    final Map<DateTime, List<BookingEntity>> grouped = {};

    for (var booking in bookings) {
      try {
        final parsed = DateTime.tryParse(booking.scheduledDate);
        if (parsed != null) {
          final dateKey = DateTime(parsed.year, parsed.month, parsed.day);
          if (!grouped.containsKey(dateKey)) {
            grouped[dateKey] = [];
          }
          grouped[dateKey]!.add(booking);
        }
      } catch (_) {}
    }
    return grouped;
  }
}
