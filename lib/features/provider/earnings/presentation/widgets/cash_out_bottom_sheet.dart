import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/utils/form_validators.dart';
import '../../../../../../injection_container.dart';
import '../cubit/cash_out_cubit.dart';

class CashOutBottomSheet extends StatefulWidget {
  final double maxAmount;
  final VoidCallback onSuccess;

  const CashOutBottomSheet({
    super.key,
    required this.maxAmount,
    required this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required double maxAmount,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => CashOutCubit(
          cashOutUseCase: InjectionContainer.instance.cashOutUseCase,
        ),
        child: CashOutBottomSheet(maxAmount: maxAmount, onSuccess: onSuccess),
      ),
    );
  }

  @override
  State<CashOutBottomSheet> createState() => _CashOutBottomSheetState();
}

class _CashOutBottomSheetState extends State<CashOutBottomSheet> {
  late TextEditingController _amountController;
  late TextEditingController _upiIdController;
  late GlobalKey<FormState> _formKey;

  @override
  initState() {
    super.initState();
    _amountController = TextEditingController();
    _upiIdController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CashOutCubit, CashOutState>(
      listener: (context, state) {
        if (state is CashOutSuccess) {
          Navigator.pop(context);
          widget.onSuccess();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cash Out Successful..!!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is CashOutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.lg,
          left: AppSizes.lg,
          right: AppSizes.lg,
          top: AppSizes.sm,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Title & Available Balance
              Text('Cash Out', style: AppTextStyles.h3),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Available Balance: ₹${widget.maxAmount.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Minimum Amount Warning
              if (widget.maxAmount < 100) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Minimum cash out amount is ₹100.00. You need at least ₹${(100.00 - widget.maxAmount).toStringAsFixed(2)} more to cash out.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
              ],
              // Amount Input
              CustomTextField(
                controller: _amountController,
                labelText: 'Amount (₹)',
                hintText: 'Enter amount',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => FormValidators.validateCashOutAmount(
                  value,
                  widget.maxAmount,
                ),
                suffixIcon: widget.maxAmount >= 100
                    ? TextButton(
                        onPressed: () {
                          _amountController.text = widget.maxAmount
                              .toStringAsFixed(2);
                        },
                        child: Text(
                          'Use Max',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: AppSizes.md),

              // UPI ID Input
              CustomTextField(
                controller: _upiIdController,
                labelText: 'UPI ID',
                hintText: 'example@upi',
                validator: FormValidators.validateUpiId,
              ),
              const SizedBox(height: AppSizes.lg),
              BlocBuilder<CashOutCubit, CashOutState>(
                builder: (context, state) {
                  final bool canCashOut = widget.maxAmount >= 100;
                  return CustomButton(
                    text: 'Confirm Cash Out',
                    isLoading: state is CashOutLoading,
                    onPressed: canCashOut
                        ? () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<CashOutCubit>().cashOut(
                                double.parse(_amountController.text),
                                _upiIdController.text,
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
