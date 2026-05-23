import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';

class PromoDiscountTypeSelector extends StatelessWidget {
  const PromoDiscountTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePromoFormCubit>();

    return BlocBuilder<CreatePromoFormCubit, CreatePromoFormState>(
      builder: (context, state) {
        final discountType = state.discountType;
        return Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(
                  child: Text("Percentage (%)", style: TextStyle(fontSize: 12)),
                ),
                selected: discountType == 'percentage',
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: discountType == 'percentage'
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.setDiscountType('percentage');
                  }
                },
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: ChoiceChip(
                label: const Center(
                  child: Text(
                    "Flat Amount (₹)",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                selected: discountType == 'flat',
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: discountType == 'flat'
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.setDiscountType('flat');
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
