import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_state.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/components/promo_discount_type_selector.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/components/promo_code_input_section.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/components/promo_discount_value_section.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/components/promo_limits_section.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/components/promo_expiry_section.dart';

class CreatePromoForm extends StatefulWidget {
  final ProviderPromoCubit cubit;

  const CreatePromoForm({super.key, required this.cubit});

  @override
  State<CreatePromoForm> createState() => _CreatePromoFormState();
}

class _CreatePromoFormState extends State<CreatePromoForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountValueController;
  late TextEditingController _minAmountController;
  late TextEditingController _maxUsesController;
  late TextEditingController _maxDiscountController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _codeController = TextEditingController();
    _descriptionController = TextEditingController();
    _discountValueController = TextEditingController();
    _minAmountController = TextEditingController();
    _maxUsesController = TextEditingController();
    _maxDiscountController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minAmountController.dispose();
    _maxUsesController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }

  void _onCreatePromoPressed(String discountType, DateTime? expiresAt) {
    if (_formKey.currentState!.validate()) {
      widget.cubit.createPromo(
        code: _codeController.text.trim().toUpperCase(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        discountType: discountType,
        discountValue: double.parse(_discountValueController.text),
        minBookingAmount: _minAmountController.text.isEmpty
            ? null
            : double.parse(_minAmountController.text),
        maxUses: _maxUsesController.text.isEmpty
            ? null
            : int.parse(_maxUsesController.text),
        maxDiscountAmount:
            discountType == 'percentage' &&
                _maxDiscountController.text.isNotEmpty
            ? double.parse(_maxDiscountController.text)
            : null,
        expiresAt: expiresAt,
      );
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
              content: Text("Promo code created successfully!"),
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
            // Promo Code & Description
            PromoCodeInputSection(
              codeController: _codeController,
              descriptionController: _descriptionController,
            ),
            const SizedBox(height: AppSizes.md),
            const Text(
              "Discount Type",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),

            // Discount Type Selector
            const PromoDiscountTypeSelector(),
            const SizedBox(height: AppSizes.md),

            // Discount Value & Min Amount
            PromoDiscountValueSection(
              discountValueController: _discountValueController,
              minAmountController: _minAmountController,
            ),
            const SizedBox(height: AppSizes.md),

            // Promo Limits
            PromoLimitsSection(
              maxUsesController: _maxUsesController,
              maxDiscountController: _maxDiscountController,
            ),

            // Expiry Date
            const PromoExpirySection(),
            const SizedBox(height: AppSizes.lg),
            BlocBuilder<ProviderPromoCubit, ProviderPromoState>(
              bloc: widget.cubit,
              builder: (context, providerState) {
                return BlocBuilder<CreatePromoFormCubit, CreatePromoFormState>(
                  builder: (context, formState) {
                    final discountType = formState.discountType;
                    return CustomButton(
                      text: "Create Promo",
                      isLoading:
                          providerState.status ==
                          ProviderPromoStatus.submitting,
                      onPressed: () => _onCreatePromoPressed(
                        discountType,
                        formState.expiresAt,
                      ),
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
