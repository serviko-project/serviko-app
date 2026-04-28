import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/fill_profile_cubit.dart';
import 'package:serviko_app/features/user/auth/presentation/widgets/gender_selection_widget.dart';
import 'package:serviko_app/features/user/auth/presentation/widgets/profile_image_picker_widget.dart';
import 'package:serviko_app/injection_container.dart';

// Fill profile screen — collects user's basic information after sign-up.
class FillProfileScreen extends StatelessWidget {
  const FillProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FillProfileCubit(
        createUserProfileUseCase:
            InjectionContainer.instance.createUserProfileUseCase,
        uploadProfileImageUseCase:
            InjectionContainer.instance.uploadProfileImageUseCase,
        deleteProfileImageUseCase:
            InjectionContainer.instance.deleteProfileImageUseCase,
      ),
      child: const _FillProfileView(),
    );
  }
}

class _FillProfileView extends StatelessWidget {
  const _FillProfileView();

  Future<void> _onPickDate(BuildContext context) async {
    final cubit = context.read<FillProfileCubit>();
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

  void _onContinue(BuildContext context) {
    context.read<FillProfileCubit>().submitProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FillProfileCubit, FillProfileState>(
      listener: (context, state) {
        if (state.status == FillProfileStatus.success) {
          context.pushNamed(AppRouter.address);
        } else if (state.status == FillProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();

    return Form(
      key: cubit.formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.xl),

          const SizedBox(height: AppSizes.xl),

          // ---- Header ----
          Text(
            'Fill Your Profile ✏️',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            "Don't worry, you can always change it later.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.xl),

          // ---- Profile Image Picker ----
          ProfileImagePickerWidget(),
          const SizedBox(height: AppSizes.xl),

          // ---- Full Name ----
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

          // ---- Gender ----
          const GenderSelectionWidget(),
          const SizedBox(height: AppSizes.md),

          // ---- Date of Birth ----
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
          const SizedBox(height: AppSizes.md),

          // ---- Phone Number ----
          CustomTextField(
            hintText: 'Phone Number',
            controller: cubit.phoneController,
            focusNode: cubit.phoneFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: FormValidators.validatePhone,
          ),
          const SizedBox(height: AppSizes.xl),

          // ---- Continue Button ----
          BlocBuilder<FillProfileCubit, FillProfileState>(
            buildWhen: (prev, curr) => prev.status != curr.status,
            builder: (context, state) {
              final isLoading = state.status == FillProfileStatus.submitting;
              return CustomButton(
                text: isLoading ? 'Creating Profile...' : 'Continue',
                onPressed: isLoading ? null : () => _onContinue(context),
              );
            },
          ),
          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }
}
