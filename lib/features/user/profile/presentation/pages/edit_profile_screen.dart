import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/edit_profile_state.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/edit_profile_image_picker.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/edit_gender_selection.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditProfileCubit(profileCubit: context.read<ProfileCubit>()),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  Future<void> _onPickDate(BuildContext context) async {
    final cubit = context.read<EditProfileCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      cubit.setDateOfBirth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        } else if (state.status == EditProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to update profile'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Edit Profile"),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  // Builds the Form with fields for editing profile information
  Widget _buildForm(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EditProfileImagePicker(),
          const SizedBox(height: AppSizes.xl),

          Text(
            'Full Name',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          CustomTextField(
            hintText: 'Full Name',
            controller: cubit.fullNameController,
            focusNode: cubit.fullNameFocusNode,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: (value) =>
                FormValidators.validateRequired(value, 'full name'),
          ),
          const SizedBox(height: AppSizes.md),

          Text(
            'Phone Number',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          CustomTextField(
            hintText: 'Phone Number',
            controller: cubit.phoneController,
            focusNode: cubit.phoneFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: FormValidators.validatePhone,
          ),
          const SizedBox(height: AppSizes.md),

          Text(
            'Gender',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const EditGenderSelection(),
          const SizedBox(height: AppSizes.md),

          Text(
            'Date of Birth',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          CustomTextField(
            hintText: 'Date of Birth',
            controller: cubit.dobController,
            focusNode: cubit.dobFocusNode,
            readOnly: true,
            onTap: () => _onPickDate(context),
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
          ),
          const SizedBox(height: 32),

          BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              final isLoading = state.status == EditProfileStatus.submitting;
              return CustomButton(
                text: isLoading ? 'Saving...' : 'Save Changes',
                onPressed: isLoading ? null : () => cubit.submit(),
              );
            },
          ),
        ],
      ),
    );
  }
}
