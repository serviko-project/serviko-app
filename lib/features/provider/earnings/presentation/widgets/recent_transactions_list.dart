import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/earnings/presentation/widgets/transaction_list_tile.dart';
import '../../domain/entities/transaction_entity.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final VoidCallback onSeeAll;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See All',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        // Empty State
        if (transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pending_actions_outlined,
                    size: AppSizes.iconXl * 1.5,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'No recent transactions yet.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        // Transaction List
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return TransactionListTile(
                title: tx.title,
                amount: tx.amount,
                isCredit: tx.isCredit,
                dateStr: tx.dateStr,
              );
            },
          ),
      ],
    );
  }
}
