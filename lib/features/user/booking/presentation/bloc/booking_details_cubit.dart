import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import '../../domain/usecases/get_available_slots_usecase.dart';
import 'booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;
  final String providerId;

  BookingDetailsCubit({
    required GetAvailableSlotsUseCase getAvailableSlotsUseCase,
    required this.providerId,
    required double initialBasePrice,
  }) : _getAvailableSlotsUseCase = getAvailableSlotsUseCase,
       super(
         BookingDetailsState(
           selectedDate: DateTime.now(),
           basePrice: initialBasePrice,
           workingHours: 1,
         ),
       ) {
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    emit(
      state.copyWith(status: BookingDetailsStatus.loading, errorMessage: null),
    );

    final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);

    final result = await _getAvailableSlotsUseCase(
      GetAvailableSlotsParams(
        providerId: providerId,
        date: dateStr,
        durationHours: state.workingHours,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (slotsEntity) {
        // Clear selected time if it's no longer available in the new list
        String selected = state.selectedStartTime;
        if (!slotsEntity.slots.contains(selected)) {
          selected = '';
        }

        emit(
          state.copyWith(
            status: BookingDetailsStatus.success,
            availableStartTimes: slotsEntity.slots,
            maxDurationFromSlot: slotsEntity.maxDurationFromSlot,
            selectedStartTime: selected,
          ),
        );
      },
    );
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    _fetchAvailableSlots();
  }

  void incrementHours() {
    if (state.workingHours < 8) {
      emit(state.copyWith(workingHours: state.workingHours + 1));
      _fetchAvailableSlots();
    }
  }

  void decrementHours() {
    if (state.workingHours > 1) {
      emit(state.copyWith(workingHours: state.workingHours - 1));
      _fetchAvailableSlots();
    }
  }

  void selectStartTime(String time) {
    emit(state.copyWith(selectedStartTime: DateTimeUtils.formatTo24Hour(time)));
  }

  void updatePromoCode(String code) {
    emit(state.copyWith(promoCode: code));
  }

  void applyPromoCode() {}
}
