import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_state.dart';

class EditProviderDetailsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController bioController;
  final TextEditingController experienceController;
  final VoidCallback onSave;

  const EditProviderDetailsForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.bioController,
    required this.experienceController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Professional Information', style: AppTextStyles.h3),
          const SizedBox(height: AppSizes.md),
          CustomTextField(
            controller: titleController,
            labelText: 'Professional Title',
            hintText: 'e.g. Expert Plumber, Senior Electrician',
            validator: (value) =>
                FormValidators.validateRequired(value, 'Professional title'),
          ),
          const SizedBox(height: AppSizes.md),
          CustomTextField(
            controller: bioController,
            labelText: 'Bio',
            hintText: 'Tell your customers about your services and experience',
            maxLines: 4,
          ),
          const SizedBox(height: AppSizes.md),
          CustomTextField(
            controller: experienceController,
            labelText: 'Years of Experience',
            hintText: 'e.g. 5',
            keyboardType: TextInputType.number,
            validator: (value) =>
                FormValidators.validateNumeric(value, 'Years of experience'),
          ),
          const SizedBox(height: AppSizes.xl),
          BlocBuilder<EditProviderDetailsCubit, EditProviderDetailsState>(
            builder: (context, editState) {
              final isLoading = editState is EditProviderDetailsLoading;
              return CustomButton(
                text: 'Save Details',
                onPressed: isLoading ? () {} : onSave,
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
