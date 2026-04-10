import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/auth/presentation/cubit/fill_profile_cubit.dart';
import 'package:serviko_app/features/auth/presentation/widgets/gender_selection_widget.dart';
import 'package:serviko_app/features/auth/presentation/widgets/profile_image_picker_widget.dart';

// Fill profile screen — collects user's basic information after sign-up.
class FillProfileScreen extends StatelessWidget {
  const FillProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FillProfileCubit(),
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
      cubit.dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  void _onContinue(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();
    if (!(cubit.formKey.currentState?.validate() ?? false)) return;

    // TODO: Save User's profile data
    context.pushNamed(AppRouter.address);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Form(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final phoneRegex = RegExp(r'^\d{10}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.xl),

                // ---- Continue Button ----
                CustomButton(
                  text: 'Continue',
                  onPressed: () => _onContinue(context),
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
