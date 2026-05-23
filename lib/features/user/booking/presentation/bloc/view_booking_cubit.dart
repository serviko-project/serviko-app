import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/submit_review_usecase.dart';
import 'view_booking_state.dart';

class ViewBookingCubit extends Cubit<ViewBookingState> {
  final GetBookingDetailUseCase getBookingDetailUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final SubmitReviewUseCase submitReviewUseCase;

  ViewBookingCubit({
    required this.getBookingDetailUseCase,
    required this.cancelBookingUseCase,
    required this.submitReviewUseCase,
  }) : super(const ViewBookingState());

  Future<void> fetchBookingDetails(String bookingId) async {
    emit(state.copyWith(status: ViewBookingStatus.loading));

    final result = await getBookingDetailUseCase(
      GetBookingDetailParams(bookingId: bookingId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewBookingStatus.error,
          message: failure.message,
        ),
      ),
      (booking) => emit(
        state.copyWith(status: ViewBookingStatus.loaded, booking: booking),
      ),
    );
  }

  Future<void> cancelBooking(String bookingId) async {
    emit(state.copyWith(actionStatus: ViewBookingActionStatus.loading));

    final result = await cancelBookingUseCase(
      CancelBookingParams(bookingId: bookingId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            actionStatus: ViewBookingActionStatus.error,
            message: failure.message,
          ),
        );
      },
      (booking) {
        emit(
          state.copyWith(
            actionStatus: ViewBookingActionStatus.success,
            message: 'Booking cancelled successfully',
            booking: booking,
          ),
        );
        emit(state.copyWith(actionStatus: ViewBookingActionStatus.none));
      },
    );
  }

  Future<void> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    emit(state.copyWith(actionStatus: ViewBookingActionStatus.loading));

    final result = await submitReviewUseCase(
      SubmitReviewParams(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            actionStatus: ViewBookingActionStatus.error,
            message: failure.message,
          ),
        );
      },
      (review) {
        final updatedBooking = state.booking?.copyWith(hasReview: true);
        emit(
          state.copyWith(
            actionStatus: ViewBookingActionStatus.success,
            message: 'Review submitted successfully',
            booking: updatedBooking,
          ),
        );
        emit(state.copyWith(actionStatus: ViewBookingActionStatus.none));
      },
    );
  }
}
