import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/features/auth/presentation/cubit/fill_profile_cubit.dart';

// Gender Selection Widget
class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();

    return BlocBuilder<FillProfileCubit, FillProfileState>(
      buildWhen: (prev, curr) => prev.gender != curr.gender,
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          initialValue: state.gender,
          decoration: InputDecoration(
            hintText: 'Gender',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textHint,
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          items: FillProfileCubit.genderOptions.map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          onChanged: (value) => cubit.updateGender(value),
          validator: (value) =>
              FormValidators.validateRequired(value, 'gender'),
        );
      },
    );
  }
}
