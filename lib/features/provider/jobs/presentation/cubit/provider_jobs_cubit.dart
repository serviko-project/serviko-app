import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(ProviderJobsLoading(bookings: state.bookings));
    } else if (state is ProviderJobsInitial) {
      emit(const ProviderJobsLoading());
    } else if (state is ProviderJobsLoaded &&
        (state as ProviderJobsLoaded).hasReachedMax) {
      return;
    }

    final result = await getProviderBookingsUseCase(
      GetProviderBookingsParams(page: _currentPage, limit: 20),
    );

    result.fold(
      (failure) {
        emit(ProviderJobsError(failure.message, bookings: state.bookings));
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
          emit(
            ProviderJobsLoaded(
              bookings: (state.bookings ?? []) + bookings,
              hasReachedMax: bookings.length < 20,
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
    emit(ProviderJobUpdating(bookingId, state.bookings ?? []));

    final result = await reviewBookingUseCase(
      ReviewBookingParams(
        bookingId: bookingId,
        action: action,
        rejectionReason: rejectionReason,
      ),
    );

    result.fold(
      (failure) {
        emit(
          ProviderJobsError(failure.message, bookings: currentState.bookings),
        );
        // Restore previous list if possible
        if (currentState is ProviderJobsLoaded) {
          emit(currentState);
        }
      },
      (updatedBooking) {
        final currentBookings = currentState.bookings ?? [];
        final updatedList = currentBookings.map((b) {
          return b.id == updatedBooking.id ? updatedBooking : b;
        }).toList();
        final hasReachedMax = currentState is ProviderJobsLoaded
            ? currentState.hasReachedMax
            : false;
        emit(ProviderJobUpdated(updatedBooking, updatedList));
        emit(
          ProviderJobsLoaded(
            bookings: updatedList,
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );
  }
}
