import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_customer_bookings_usecase.dart';
import 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final GetCustomerBookingsUseCase getCustomerBookingsUseCase;

  MyBookingsCubit({required this.getCustomerBookingsUseCase})
    : super(MyBookingsInitial());

  Future<void> fetchBookings() async {
    emit(MyBookingsLoading());

    final result = await getCustomerBookingsUseCase(
      const GetCustomerBookingsParams(limit: 20),
    );

    result.fold((failure) => emit(MyBookingsError(message: failure.message)), (
      bookings,
    ) {
      final upcoming = bookings
          .where(
            (b) =>
                b.status == BookingStatus.pending ||
                b.status == BookingStatus.confirmed,
          )
          .toList();

      final completed = bookings
          .where((b) => b.status == BookingStatus.completed)
          .toList();

      final cancelled = bookings
          .where(
            (b) =>
                b.status == BookingStatus.cancelled ||
                b.status == BookingStatus.rejected ||
                b.status == BookingStatus.expired,
          )
          .toList();

      emit(
        MyBookingsLoaded(
          upcomingBookings: upcoming,
          completedBookings: completed,
          cancelledBookings: cancelled,
        ),
      );
    });
  }
}
