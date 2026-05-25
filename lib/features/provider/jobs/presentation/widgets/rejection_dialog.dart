import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import '../cubit/provider_jobs_cubit.dart';

void showRejectionDialog(BuildContext context, String bookingId) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Reject Booking', style: AppTextStyles.h3),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please provide a reason for rejecting this booking.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: controller,
              maxLines: 3,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Enter reason here...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.all(AppSizes.sm + 4),
              ),
              validator: (value) =>
                  FormValidators.validateRequired(value, 'reason'),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm + 4,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogContext);
                    context.read<ProviderJobsCubit>().reviewBooking(
                      bookingId: bookingId,
                      action: 'reject',
                      rejectionReason: controller.text.trim(),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  minimumSize: const Size(0, 36),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
                child: Text(
                  'Reject',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
