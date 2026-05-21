import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/faq_cubit.dart';

// Expandable accordion tile displaying FAQ item
class FaqAccordionTile extends StatelessWidget {
  final FaqItem faq;

  const FaqAccordionTile({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    final expandedFaqId = context.watch<FaqCubit>().state.expandedFaqId;
    final isExpanded = expandedFaqId == faq.id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? AppColors.primary.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.01),
            blurRadius: AppSizes.radiusMd,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accordion Header
          InkWell(
            onTap: () => context.read<FaqCubit>().toggleFaq(faq.id),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
                vertical: AppSizes.lg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isExpanded
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 250),
                    turns: isExpanded ? 0.5 : 0.0,
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: isExpanded
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: AppSizes.iconSm,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Accordion Body
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                0,
                AppSizes.screenPadding,
                AppSizes.screenPadding,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    faq.answer,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
