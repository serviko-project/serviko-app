import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import '../../../../user/booking/domain/usecases/get_provider_bookings_usecase.dart';
import '../../../../user/booking/domain/usecases/review_booking_usecase.dart';
import 'provider_jobs_state.dart';

class ProviderJobsCubit extends Cubit<ProviderJobsState> {
  final GetProviderBookingsUseCase getProviderBookingsUseCase;
  final ReviewBookingUseCase reviewBookingUseCase;

  ProviderJobsCubit({
    required this.getProviderBookingsUseCase,
    required this.reviewBookingUseCase,
  }) : super(ProviderJobsInitial());

  int _currentPage = 1;

  Future<void> getBookings({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      final currentBookings = state is ProviderJobsLoaded
          ? (state as ProviderJobsLoaded).bookings
          : (state is ProviderJobsLoading
                ? (state as ProviderJobsLoading).bookings
                : <BookingEntity>[]);
      emit(ProviderJobsLoading(bookings: currentBookings));
    } else if (state is ProviderJobsInitial) {
      emit(const ProviderJobsLoading());
    } else if (state is ProviderJobsLoaded &&
        (state as ProviderJobsLoaded).hasReachedMax) {
      return;
    }

    final result = await getProviderBookingsUseCase(
      GetProviderBookingsParams(page: _currentPage),
    );

    result.fold(
      (failure) {
        List<BookingEntity>? currentBookings;
        if (state is ProviderJobsLoaded) {
          currentBookings = (state as ProviderJobsLoaded).bookings;
        }
        emit(ProviderJobsError(failure.message, bookings: currentBookings));
      },
      (bookings) {
        if (refresh || state is! ProviderJobsLoaded) {
          emit(
            ProviderJobsLoaded(
              bookings: bookings,
              hasReachedMax: bookings.length < 20,
            ),
          );
        } else {
          final currentBookings = (state as ProviderJobsLoaded).bookings;
          emit(
            ProviderJobsLoaded(
              bookings: currentBookings + bookings,
              hasReachedMax: bookings.isEmpty,
            ),
          );
        }
        _currentPage++;
      },
    );
  }

  Future<void> reviewBooking({
    required String bookingId,
    required String action,
    String? rejectionReason,
  }) async {
    final currentState = state;
    if (currentState is ProviderJobsLoaded) {
      emit(ProviderJobUpdating(bookingId, currentState.bookings));
    } else {
      emit(ProviderJobUpdating(bookingId, const []));
    }

    final result = await reviewBookingUseCase(
      ReviewBookingParams(
        bookingId: bookingId,
        action: action,
        rejectionReason: rejectionReason,
      ),
    );

    result.fold(
      (failure) {
        List<BookingEntity>? currentBookings;
        if (currentState is ProviderJobsLoaded) {
          currentBookings = currentState.bookings;
        }
        emit(ProviderJobsError(failure.message, bookings: currentBookings));
        // Restore previous list if possible
        if (currentState is ProviderJobsLoaded) {
          emit(currentState);
        }
      },
      (updatedBooking) {
        if (currentState is ProviderJobsLoaded) {
          final updatedList = currentState.bookings.map((b) {
            return b.id == updatedBooking.id ? updatedBooking : b;
          }).toList();
          emit(ProviderJobUpdated(updatedBooking, updatedList));
          emit(
            ProviderJobsLoaded(
              bookings: updatedList,
              hasReachedMax: currentState.hasReachedMax,
            ),
          );
        } else {
          emit(ProviderJobUpdated(updatedBooking, const []));
        }
      },
    );
  }
}
