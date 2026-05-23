import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/create_promo_form.dart';

class CreatePromoBottomSheet extends StatelessWidget {
  final ProviderPromoCubit cubit;

  const CreatePromoBottomSheet({super.key, required this.cubit});

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
            Text(
              "Create Promo Code",
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.md),
            BlocProvider(
              create: (context) => CreatePromoFormCubit(),
              child: CreatePromoForm(cubit: cubit),
            ),
          ],
        ),
      ),
    );
  }
}
