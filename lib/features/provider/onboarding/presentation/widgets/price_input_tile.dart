import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Per-category price input tile with validation
class PriceInputTile extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final IconData categoryIcon;
  final double? currentPrice;
  final bool hasError;
  final ValueChanged<double> onPriceChanged;

  const PriceInputTile({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryIcon,
    this.currentPrice,
    this.hasError = false,
    required this.onPriceChanged,
  });

  @override
  State<PriceInputTile> createState() => _PriceInputTileState();
}

class _PriceInputTileState extends State<PriceInputTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentPrice != null && widget.currentPrice! > 0
          ? widget.currentPrice!.toStringAsFixed(
              widget.currentPrice! == widget.currentPrice!.roundToDouble()
                  ? 0
                  : 2,
            )
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPrice = (widget.currentPrice ?? 0) > 0;

    final borderColor = widget.hasError
        ? AppColors.error.withAlpha(180)
        : hasPrice
        ? AppColors.success.withAlpha(120)
        : AppColors.border.withAlpha(120);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 4,
      ),
      decoration: BoxDecoration(
        color: widget.hasError ? AppColors.error.withAlpha(6) : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          // Category icon
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: widget.hasError
                  ? AppColors.error.withAlpha(15)
                  : AppColors.primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.categoryIcon,
              color: widget.hasError ? AppColors.error : AppColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(width: AppSizes.md),

          // Category name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryTitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Rate required',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),

          // Price input field
          SizedBox(
            width: 115,
            child: TextFormField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
                prefixText: '₹',
                prefixStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                suffixText: '/hr',
                suffixStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
                contentPadding: const EdgeInsets.all(10),
                isDense: true,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  borderSide: BorderSide(
                    color: widget.hasError
                        ? AppColors.error.withAlpha(120)
                        : AppColors.border.withAlpha(120),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  borderSide: BorderSide(
                    color: widget.hasError
                        ? AppColors.error
                        : AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) {
                final price = double.tryParse(value) ?? 0;
                widget.onPriceChanged(price);
              },
            ),
          ),

          // Check icon when valid
          if (hasPrice) ...[
            const SizedBox(width: AppSizes.xs),
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }
}
