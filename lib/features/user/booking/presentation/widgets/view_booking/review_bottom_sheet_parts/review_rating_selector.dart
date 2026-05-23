import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_state.dart';

class ReviewRatingSelector extends StatelessWidget {
  const ReviewRatingSelector({super.key});

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great!';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap a star to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewFormCubit, ReviewFormState>(
      buildWhen: (previous, current) =>
          previous.selectedRating != current.selectedRating,
      builder: (context, state) {
        return Column(
          children: [
            // Rating label
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getRatingLabel(state.selectedRating),
                key: ValueKey<int>(state.selectedRating),
                style: AppTextStyles.h3.copyWith(
                  color: state.selectedRating > 0
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: state.selectedRating > 0 ? 17 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Star Rating Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isSelected = starIndex <= state.selectedRating;
                return GestureDetector(
                  onTap: () {
                    context.read<ReviewFormCubit>().updateRating(starIndex);
                  },
                  child: AnimatedScale(
                    scale: isSelected ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        isSelected
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isSelected ? Colors.amber : AppColors.border,
                        size: 44,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
