import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/update_provider_availability_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_availability_state.dart';

class EditProviderAvailabilityCubit
    extends Cubit<EditProviderAvailabilityState> {
  final UpdateProviderAvailabilityUseCase _updateProviderAvailabilityUseCase;

  EditProviderAvailabilityCubit({
    required UpdateProviderAvailabilityUseCase
    updateProviderAvailabilityUseCase,
  }) : _updateProviderAvailabilityUseCase = updateProviderAvailabilityUseCase,
       super(const EditProviderAvailabilityState());

  void init(List<ProviderAvailabilityEntity> currentAvailability) {
    emit(state.copyWith(status: EditProviderAvailabilityStatus.loading));
    final availabilityMap = <int, DayAvailability>{};

    // Default availability for 7 days
    for (int i = 1; i <= 7; i++) {
      availabilityMap[i] = const DayAvailability(
        isEnabled: false,
        startTime: TimeOfDay(hour: 9, minute: 0),
        endTime: TimeOfDay(hour: 17, minute: 0),
      );
    }

    // Populate from current settings
    for (final slot in currentAvailability) {
      availabilityMap[slot.dayOfWeek] = DayAvailability(
        isEnabled: slot.isEnabled,
        startTime: _parseTimeString(slot.startTime),
        endTime: _parseTimeString(slot.endTime),
      );
    }

    emit(
      state.copyWith(
        status: EditProviderAvailabilityStatus.loaded,
        availability: availabilityMap,
      ),
    );
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void toggleDay(int dayNumber) {
    if (state.status == EditProviderAvailabilityStatus.loaded ||
        state.status == EditProviderAvailabilityStatus.error ||
        state.status == EditProviderAvailabilityStatus.updating) {
      final availability = Map<int, DayAvailability>.from(state.availability);
      final current = availability[dayNumber];
      if (current != null) {
        availability[dayNumber] = current.copyWith(
          isEnabled: !current.isEnabled,
        );
        emit(state.copyWith(availability: availability));
      }
    }
  }

  void setTimeForDay(
    int dayNumber, {
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    if (state.status == EditProviderAvailabilityStatus.loaded ||
        state.status == EditProviderAvailabilityStatus.error ||
        state.status == EditProviderAvailabilityStatus.updating) {
      final availability = Map<int, DayAvailability>.from(state.availability);
      final current = availability[dayNumber];
      if (current != null) {
        availability[dayNumber] = current.copyWith(
          startTime: startTime ?? current.startTime,
          endTime: endTime ?? current.endTime,
        );
        emit(state.copyWith(availability: availability));
      }
    }
  }

  Future<void> saveAvailability() async {
    emit(state.copyWith(status: EditProviderAvailabilityStatus.updating));

    final payload = <Map<String, dynamic>>[];
    for (int i = 1; i <= 7; i++) {
      final slot = state.availability[i]!;
      payload.add({
        'day_of_week': i,
        'is_enabled': slot.isEnabled,
        'start_time': DayAvailability.formatTime(slot.startTime),
        'end_time': DayAvailability.formatTime(slot.endTime),
      });
    }

    final result = await _updateProviderAvailabilityUseCase(
      UpdateProviderAvailabilityParams(availability: payload),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditProviderAvailabilityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: EditProviderAvailabilityStatus.success,
          successMessage: 'Availability schedule updated successfully',
        ),
      ),
    );
  }

  void clearError() => emit(
    state.copyWith(
      status: EditProviderAvailabilityStatus.loaded,
      clearError: true,
    ),
  );
  void clearSuccess() => emit(state.copyWith(clearSuccess: true));
}
