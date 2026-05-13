import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/route_constants.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Review Summary"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryDetailsCard(),
            const SizedBox(height: AppSizes.md),

            _buildPriceSummaryCard(),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: CustomButton(
            text: "Send Request",
            onPressed: () {
              context.pushNamed(RouteNames.bookingSuccess);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.md,
        children: [
          _buildDetailRow("Provider", "Jenny Wilson"),
          _buildDetailRow("Category", "Cleaning"),
          _buildDetailRow("Date", "Dec 23, 2024"),
          _buildDetailRow("Starting Time", "10:00 AM"),
          _buildDetailRow("Working Hours", "2 hours"),
          _buildDetailRow("Location", "Malappuram, Kerala"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: color ?? AppColors.textSecondary,
            letterSpacing: 0.5,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontSize: 13,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: AppSizes.md,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("House Cleaning", "₹ 125.00"),
          _buildDetailRow("Discount", "- ₹ 25.00", AppColors.primary),
          Divider(color: AppColors.border.withValues(alpha: 0.5)),
          _buildDetailRow("Discount", "- ₹ 25.00", AppColors.primary),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: AppTextStyles.h3.copyWith(letterSpacing: 0.5),
              ),
              Text(
                "₹ 100",
                style: AppTextStyles.h3.copyWith(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
