import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';

class PromoDiscountValueSection extends StatelessWidget {
  final TextEditingController discountValueController;
  final TextEditingController minAmountController;

  const PromoDiscountValueSection({
    super.key,
    required this.discountValueController,
    required this.minAmountController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePromoFormCubit, CreatePromoFormState>(
      builder: (context, formState) {
        final discountType = formState.discountType;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discount Value
            Expanded(
              child: CustomTextField(
                controller: discountValueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                labelText: "Value",
                hintText: "0",
                prefixIcon: discountType == 'flat'
                    ? const Icon(
                        Icons.currency_rupee,
                        color: AppColors.textSecondary,
                        size: AppSizes.iconSm,
                      )
                    : null,
                suffixIcon: discountType == 'percentage'
                    ? const Icon(
                        Icons.percent,
                        color: AppColors.textSecondary,
                        size: AppSizes.iconSm,
                      )
                    : null,
                validator: (value) =>
                    FormValidators.validateDiscountValue(value, discountType),
              ),
            ),
            const SizedBox(width: AppSizes.md),

            // Min Booking Amount
            Expanded(
              child: CustomTextField(
                controller: minAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                labelText: "Min Amt (Optional)",
                hintText: "0",
                prefixIcon: const Icon(
                  Icons.currency_rupee,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconSm,
                ),
                validator: FormValidators.validateOptionalMinAmount,
              ),
            ),
          ],
        );
      },
    );
  }
}
