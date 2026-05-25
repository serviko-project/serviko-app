import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/edit_promo_form_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/edit_promo_form.dart';

class EditPromoBottomSheet extends StatelessWidget {
  final ProviderPromoCubit cubit;
  final PromoCode promo;

  const EditPromoBottomSheet({
    super.key,
    required this.cubit,
    required this.promo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.screenPadding,
        right: AppSizes.screenPadding,
        top: AppSizes.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Title
            Text("Edit Promo Code", style: AppTextStyles.h3),
            const SizedBox(height: AppSizes.md),

            BlocProvider(
              create: (context) =>
                  EditPromoFormCubit(initialExpiresAt: promo.expiresAt),
              child: EditPromoForm(cubit: cubit, promo: promo),
            ),
          ],
        ),
      ),
    );
  }
}
