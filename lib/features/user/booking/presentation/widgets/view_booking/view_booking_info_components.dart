import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ViewBookingSectionTitle extends StatelessWidget {
  final String title;
  final Color? color;

  const ViewBookingSectionTitle({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: color ?? AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

class ViewBookingInfoCard extends StatelessWidget {
  final List<Widget> children;

  const ViewBookingInfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(spacing: AppSizes.md, children: children),
    );
  }
}

class ViewBookingDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final bool isBold;

  const ViewBookingDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style:
                valueStyle ??
                AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}
