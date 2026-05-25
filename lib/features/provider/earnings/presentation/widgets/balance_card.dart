import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onCashOut;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.onCashOut,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');
    final String formattedBalance = formatter.format(balance);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'AVAILABLE BALANCE',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          formattedBalance,
          style: AppTextStyles.h1.copyWith(fontSize: 36, letterSpacing: 0.5),
        ),
        const SizedBox(height: AppSizes.lg),

        // Cash Out Button
        CustomButton(
          text: 'Cash Out',
          onPressed: onCashOut,
          height: 40,
          width: double.infinity,
        ),
      ],
    );
  }
}
