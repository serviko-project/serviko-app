import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/promo_selection_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/promo_selection_state.dart';

class PromoSelectionScreen extends StatelessWidget {
  const PromoSelectionScreen({super.key});

  static final List<Map<String, dynamic>> _promos = List.generate(
    5,
    (index) => {
      'id': 'promo${index + 1}',
      'title': 'Special ${5 * (index + 1)}% Off',
      'subtitle': 'Special promo only for today',
      'iconColor': Colors.purple,
    },
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoSelectionCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Add Promo"),
        body: BlocBuilder<PromoSelectionCubit, PromoSelectionState>(
          builder: (context, state) {
            return ListView.separated(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              itemCount: _promos.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                final promo = _promos[index];
                final isSelected = state.selectedPromoId == promo['id'];

                return GestureDetector(
                  onTap: () {
                    final cubit = context.read<PromoSelectionCubit>();
                    cubit.selectPromo(promo['id']);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Promo Icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: (promo['iconColor'] as Color).withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_offer_rounded,
                            color: promo['iconColor'],
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSizes.xs),
                              Text(
                                promo['subtitle'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar:
            BlocBuilder<PromoSelectionCubit, PromoSelectionState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    text: "Apply Promo",
                    onPressed: state.selectedPromoId == null
                        ? null
                        : () {
                            final selectedPromo = _promos.firstWhere(
                              (p) => p['id'] == state.selectedPromoId,
                            );
                            context.pop(selectedPromo['title']);
                          },
                  ),
                );
              },
            ),
      ),
    );
  }
}
