import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/day_avaiability_row.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_availability_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_availability_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';

const _daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class EditProviderAvailabilityView extends StatelessWidget {
  const EditProviderAvailabilityView({super.key});

  Future<void> _pickTime(
    BuildContext context,
    int dayIndex,
    TimeOfDay initialTime,
    bool isStartTime,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final cubit = context.read<EditProviderAvailabilityCubit>();
      if (isStartTime) {
        cubit.setTimeForDay(dayIndex, startTime: picked);
      } else {
        cubit.setTimeForDay(dayIndex, endTime: picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      EditProviderAvailabilityCubit,
      EditProviderAvailabilityState
    >(
      listener: (context, state) {
        if (state.status == EditProviderAvailabilityStatus.success &&
            state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<ProviderProfileCubit>().fetchProviderProfile();
          Navigator.of(context).pop();
        } else if (state.status == EditProviderAvailabilityStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<EditProviderAvailabilityCubit>().clearError();
        }
      },
      child:
          BlocBuilder<
            EditProviderAvailabilityCubit,
            EditProviderAvailabilityState
          >(
            builder: (context, state) {
              if (state.status == EditProviderAvailabilityStatus.loading ||
                  state.status == EditProviderAvailabilityStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              final cubit = context.read<EditProviderAvailabilityCubit>();
              final isUpdating =
                  state.status == EditProviderAvailabilityStatus.updating;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 7,
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              color: AppColors.border.withAlpha(100),
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final dayNumber = index + 1;
                            final dayName = _daysOfWeek[index];
                            final availability = state.availability[dayNumber];

                            if (availability == null) {
                              return const SizedBox.shrink();
                            }

                            return DayAvailabilityRow(
                              dayName: dayName,
                              availability: availability,
                              onToggle: () => cubit.toggleDay(dayNumber),
                              onStartTimeTap: () => _pickTime(
                                context,
                                dayNumber,
                                availability.startTime,
                                true,
                              ),
                              onEndTimeTap: () => _pickTime(
                                context,
                                dayNumber,
                                availability.endTime,
                                false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: CustomButton(
                      text: 'Save Availability',
                      onPressed: isUpdating
                          ? () {}
                          : () => cubit.saveAvailability(),
                      isLoading: isUpdating,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
