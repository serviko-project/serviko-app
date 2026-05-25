import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';

class PromoLimitsSection extends StatelessWidget {
  final TextEditingController maxUsesController;
  final TextEditingController maxDiscountController;

  const PromoLimitsSection({
    super.key,
    required this.maxUsesController,
    required this.maxDiscountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: maxUsesController,
          keyboardType: TextInputType.number,
          labelText: "Max Uses Limit (Optional)",
          hintText: "Blank for unlimited",
          prefixIcon: const Icon(
            Icons.people,
            color: AppColors.textSecondary,
            size: AppSizes.iconSm,
          ),
          validator: FormValidators.validateOptionalMaxUses,
        ),
        const SizedBox(height: AppSizes.md),
        BlocBuilder<CreatePromoFormCubit, CreatePromoFormState>(
          builder: (context, formState) {
            final discountType = formState.discountType;
            if (discountType == 'percentage') {
              return Column(
                children: [
                  CustomTextField(
                    controller: maxDiscountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    labelText: "Max Discount Cap (Optional)",
                    hintText: "E.g., 150",
                    prefixIcon: const Icon(
                      Icons.currency_rupee,
                      color: AppColors.textSecondary,
                      size: AppSizes.iconSm,
                    ),
                    validator: FormValidators.validateOptionalMinAmount,
                  ),
                  const SizedBox(height: AppSizes.md),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
