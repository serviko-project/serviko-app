import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_reviews_cubit.dart';

class LoadMoreReviewsButton extends StatelessWidget {
  const LoadMoreReviewsButton({super.key, required this.providerId});

  final String providerId;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.read<ServiceReviewsCubit>().fetchReviews(providerId);
      },
      icon: const Icon(Icons.arrow_downward_rounded, size: 16),
      label: Text(
        'Load More Reviews',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
