import 'package:flutter/material.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

class BookingCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final List<dynamic> Function(DateTime)? eventLoader;
  final DateTime? firstDay;

  const BookingCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.eventLoader,
    this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      padding: const EdgeInsets.all(AppSizes.sm),
      child: TableCalendar(
        firstDay: firstDay ?? DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365 * 5)),
        focusedDay: selectedDate,
        currentDay: selectedDate,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          onDateSelected(selectedDay);
        },
        eventLoader: eventLoader,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.primary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
          titleTextStyle: AppTextStyles.h3,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.labelMedium,
          weekendStyle: AppTextStyles.labelMedium,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          weekendTextStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          todayDecoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textOnPrimary,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.textHint,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
