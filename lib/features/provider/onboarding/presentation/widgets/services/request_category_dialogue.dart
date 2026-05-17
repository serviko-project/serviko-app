import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';

class RequestCategoryDialogue extends StatefulWidget {
  final ProviderOnboardingCubit cubit;

  const RequestCategoryDialogue({super.key, required this.cubit});

  @override
  State<RequestCategoryDialogue> createState() =>
      _RequestCategoryDialogueState();
}

class _RequestCategoryDialogueState extends State<RequestCategoryDialogue> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<ProviderOnboardingCubit, ProviderOnboardingState>(
        listenWhen: (prev, curr) =>
            prev.categoryRequestSuccess != curr.categoryRequestSuccess ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.categoryRequestSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Category request submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            widget.cubit.resetCategoryRequestSuccess();
          }
        },
        builder: (context, state) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.md),
            ),
            title: Text('Request New Category', style: AppTextStyles.h2),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Cannot find your service category? Request a new one to be added.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Category Name
                    CustomTextField(
                      controller: _titleController,
                      labelText: "Category Name",
                      hintText: 'e.g., Pet Grooming',
                      validator: (value) => FormValidators.validateRequired(
                        value,
                        'Category name',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Description
                    CustomTextField(
                      controller: _descriptionController,
                      labelText: "Description",
                      hintText: 'Brief description of the service',
                      maxLines: 3,
                      validator: (value) =>
                          FormValidators.validateRequired(value, 'Description'),
                    ),
                    const SizedBox(height: 12),

                    // Proposed Base Price
                    CustomTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _priceController,
                      labelText: "Proposed Base Price (₹)",
                      hintText: 'e.g., 350',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) => FormValidators.validateNumeric(
                        value,
                        'Proposed base price',
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),

                    // Error Message
                    if (state.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.md),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Info Note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Once approved, this category will be automatically added to your profile. In the meantime, please select from the available categories.',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.only(
              left: AppSizes.md,
              right: AppSizes.md,
              bottom: AppSizes.md,
              top: AppSizes.sm,
            ),
            actions: [
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        widget.cubit.clearError();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: 45,
                      text: 'Submit',
                      isLoading: state.isSubmittingCategoryRequest,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.cubit.submitCategoryRequest(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            proposedBasePrice: double.parse(
                              _priceController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
