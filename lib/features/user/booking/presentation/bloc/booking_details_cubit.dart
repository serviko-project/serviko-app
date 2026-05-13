import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit({required double initialBasePrice})
    : super(
        BookingDetailsState(
          selectedDate: DateTime.now(),
          basePrice: initialBasePrice,
        ),
      );

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void incrementHours() {
    emit(state.copyWith(workingHours: state.workingHours + 1));
  }

  void decrementHours() {
    if (state.workingHours > 0) {
      emit(state.copyWith(workingHours: state.workingHours - 1));
    }
  }

  void selectStartTime(String time) {
    emit(state.copyWith(selectedStartTime: time));
  }

  void updatePromoCode(String code) {
    emit(state.copyWith(promoCode: code));
  }

  void applyPromoCode() {}
}
