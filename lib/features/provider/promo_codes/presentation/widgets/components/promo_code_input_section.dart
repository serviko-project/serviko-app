import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';

class PromoCodeInputSection extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController descriptionController;

  const PromoCodeInputSection({
    super.key,
    required this.codeController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Promo Code
        CustomTextField(
          controller: codeController,
          textCapitalization: TextCapitalization.characters,
          labelText: "Promo Code",
          hintText: "E.g., FESTIVE30",
          prefixIcon: const Icon(
            Icons.percent,
            color: AppColors.textSecondary,
            size: AppSizes.iconSm,
          ),
          validator: FormValidators.validatePromoCode,
        ),
        const SizedBox(height: AppSizes.md),

        // Description
        CustomTextField(
          controller: descriptionController,
          labelText: "Description (Optional)",
          hintText: "E.g., 30% off for holiday bookings",
          prefixIcon: const Icon(
            Icons.description,
            color: AppColors.textSecondary,
            size: AppSizes.iconSm,
          ),
        ),
      ],
    );
  }
}
