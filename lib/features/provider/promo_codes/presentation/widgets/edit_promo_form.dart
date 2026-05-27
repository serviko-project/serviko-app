import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_state.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/edit_promo_form_cubit.dart';

class EditPromoForm extends StatefulWidget {
  final ProviderPromoCubit cubit;
  final PromoCode promo;

  const EditPromoForm({super.key, required this.cubit, required this.promo});

  @override
  State<EditPromoForm> createState() => _EditPromoFormState();
}

class _EditPromoFormState extends State<EditPromoForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _descriptionController;
  late TextEditingController _minAmountController;
  late TextEditingController _maxUsesController;
  late TextEditingController _maxDiscountController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _descriptionController = TextEditingController(
      text: widget.promo.description,
    );
    _minAmountController = TextEditingController(
      text: widget.promo.minBookingAmount?.toStringAsFixed(0) ?? '',
    );
    _maxUsesController = TextEditingController(
      text: widget.promo.maxUses?.toString() ?? '',
    );
    _maxDiscountController = TextEditingController(
      text: widget.promo.maxDiscountAmount?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _minAmountController.dispose();
    _maxUsesController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }

  void _onUpdatePromoPressed() {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{};

      final desc = _descriptionController.text.trim();
      data['description'] = desc.isEmpty ? null : desc;

      final minAmt = _minAmountController.text.trim();
      data['min_booking_amount'] = minAmt.isEmpty ? null : double.parse(minAmt);

      final maxUses = _maxUsesController.text.trim();
      data['max_uses'] = maxUses.isEmpty ? null : int.parse(maxUses);

      if (widget.promo.discountType == 'percentage') {
        final maxDisc = _maxDiscountController.text.trim();
        data['max_discount_amount'] = maxDisc.isEmpty
            ? null
            : double.parse(maxDisc);
      } else {
        data['max_discount_amount'] = null;
      }

      final expiresAt = context.read<EditPromoFormCubit>().state.expiresAt;
      data['expires_at'] = expiresAt?.toUtc().toIso8601String();

      widget.cubit.updatePromoData(widget.promo.id, data);
    }
  }

  // Method to select expiry date
  Future<void> _selectExpiryDate(BuildContext context) async {
    final controller = context.read<EditPromoFormCubit>();

    final picked = await showDatePicker(
      context: context,
      initialDate:
          controller.state.expiresAt ??
          DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!context.mounted) return;

    if (picked != null) {
      controller.setExpiresAt(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderPromoCubit, ProviderPromoState>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state.status == ProviderPromoStatus.submitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Promo code updated successfully!"),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            CustomTextField(
              controller: _descriptionController,
              labelText: "Description (Optional)",
              hintText: "E.g., 30% off for holiday bookings",
              prefixIcon: const Icon(
                Icons.description,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Min Booking Amount
            CustomTextField(
              controller: _minAmountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              labelText: "Min Booking Amount (Optional)",
              hintText: "E.g., 500",
              prefixIcon: const Icon(
                Icons.currency_rupee,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
              validator: FormValidators.validateOptionalMinAmount,
            ),
            const SizedBox(height: AppSizes.md),

            // Max Uses Limit
            CustomTextField(
              controller: _maxUsesController,
              keyboardType: TextInputType.number,
              labelText: "Max Uses Limit (Optional)",
              hintText: "Blank for unlimited",
              prefixIcon: const Icon(
                Icons.people,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
              validator: FormValidators.validateOptionalMaxUses,
            ),

            // Max Discount Cap (Only for Percentage)
            if (widget.promo.discountType == 'percentage') ...[
              const SizedBox(height: AppSizes.md),
              CustomTextField(
                controller: _maxDiscountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                labelText: "Max Discount Cap (Optional)",
                hintText: "E.g., 150",
                prefixIcon: const Icon(
                  Icons.currency_rupee,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconSm,
                ),
                validator: FormValidators.validateOptionalMinAmount,
              ),
            ],
            const SizedBox(height: AppSizes.md),

            // Expiry Date Selector
            BlocBuilder<EditPromoFormCubit, EditPromoFormState>(
              builder: (context, formState) {
                final expiresAt = formState.expiresAt;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        expiresAt == null
                            ? "No Expiry Date Set"
                            : "Expires: ${DateFormat('dd MMM yyyy').format(expiresAt)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectExpiryDate(context),
                      child: Text(expiresAt == null ? "Set Expiry" : "Change"),
                    ),
                    if (expiresAt != null)
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.error,
                          size: 20,
                        ),
                        onPressed: () {
                          final controller = context.read<EditPromoFormCubit>();
                          controller.setExpiresAt(null);
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSizes.lg),
            BlocBuilder<ProviderPromoCubit, ProviderPromoState>(
              bloc: widget.cubit,
              builder: (context, providerState) {
                return BlocBuilder<EditPromoFormCubit, EditPromoFormState>(
                  builder: (context, formState) {
                    return CustomButton(
                      text: "Update Promo",
                      isLoading:
                          providerState.status ==
                          ProviderPromoStatus.submitting,
                      onPressed: () => _onUpdatePromoPressed(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
