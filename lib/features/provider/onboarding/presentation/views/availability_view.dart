import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/day_avaiability_row.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';

const _daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class AvailabilityView extends StatelessWidget {
  const AvailabilityView({super.key});

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
      final cubit = context.read<ProviderOnboardingCubit>();
      if (isStartTime) {
        cubit.setTimeForDay(dayIndex, startTime: picked);
      } else {
        cubit.setTimeForDay(dayIndex, endTime: picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProviderOnboardingCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding + 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSizes.lg),
          // Top Information Banner
          const InfoBanner(
            text:
                'Set the hours you are generally available for work. You can adjust this schedule at any time.',
          ),
          const SizedBox(height: AppSizes.md),

          // Smart Scheduling Banner
          const InfoBanner(
            text:
                'Tip: Most successful providers offer 20+ hours per week across 4+ days to maximize their booking potential.',
            icon: Icons.auto_awesome_rounded,
            color: Colors.amber,
          ),
          const SizedBox(height: AppSizes.xl),

          // Availability List
          BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
            builder: (context, state) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 7,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  child: Container(
                    height: 1,
                    color: AppColors.border.withAlpha(100),
                  ),
                ),
                itemBuilder: (context, index) {
                  final dayNumber = index + 1;
                  final dayName = _daysOfWeek[index];
                  final availability = state.availability[dayNumber];

                  if (availability == null) return const SizedBox.shrink();

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
              );
            },
          ),
          const SizedBox(height: AppSizes.xl * 2),
        ],
      ),
    );
  }
}
