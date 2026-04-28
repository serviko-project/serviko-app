import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

class NumberStepperWidget extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String suffix;

  const NumberStepperWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 50,
    this.suffix = '',
  });

  void _decrement() {
    if (value > min) {
      onChanged(value - 1);
    }
  }

  void _increment() {
    if (value < max) {
      onChanged(value + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMin = value <= min;
    final isMax = value >= max;

    return Container(
      height: AppSizes.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: isMin ? null : _decrement,
            icon: const Icon(Icons.remove),
            color: isMin ? AppColors.textHint : AppColors.primary,
          ),
          Text(
            '$value $suffix',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: isMax ? null : _increment,
            icon: const Icon(Icons.add),
            color: isMax ? AppColors.textHint : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
