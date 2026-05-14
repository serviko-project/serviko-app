import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

class BookingBottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onContinue;
  final bool isEnabled;

  const BookingBottomBar({
    super.key,
    required this.price,
    required this.onContinue,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: isEnabled ? onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColors.primary : AppColors.divider,
            foregroundColor: isEnabled
                ? AppColors.textOnPrimary
                : AppColors.textSecondary,
            elevation: isEnabled ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
          child: Text(
            'Continue - ₹${price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isEnabled
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
