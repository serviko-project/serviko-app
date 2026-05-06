import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

class FilterChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final bool showStar;

  const FilterChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.sm),
      child: ChoiceChip(
        label: showStar
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(label),
                ],
              )
            : Text(label),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.background,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          side: isSelected
              ? BorderSide.none
              : const BorderSide(color: AppColors.border),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
      ),
    );
  }
}
