import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/auth/presentation/cubit/create_new_password_cubit.dart';

// Create new password screen
class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateNewPasswordCubit(),
      child: const _CreateNewPasswordView(),
    );
  }
}

class _CreateNewPasswordView extends StatelessWidget {
  const _CreateNewPasswordView();

  void _onContinue(BuildContext context) {
    final cubit = context.read<CreateNewPasswordCubit>();
    if (!(cubit.formKey.currentState?.validate() ?? false)) return;

    // TODO: Update password with Firebase Auth
    context.pushNamed(AppRouter.resetSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateNewPasswordCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xl),

                // ---- Back button ----
                BackButtonWidget(),
                const SizedBox(height: AppSizes.xl),

                // ---- Header ----
                Text(
                  'Create New Password 🔐',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Create your new password. If you forget it, '
                  'you can reset it again.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // ---- New Password ----
                CustomTextField(
                  hintText: 'New Password',
                  controller: cubit.passwordController,
                  focusNode: cubit.passwordFocusNode,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.md),

                // ---- Confirm Password ----
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: cubit.confirmPasswordController,
                  focusNode: cubit.confirmPasswordFocusNode,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != cubit.passwordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.lg),

                // ---- Remember me ----
                BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: state.rememberMe,
                            onChanged: (v) =>
                                cubit.toggleRememberMe(v ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          'Remember me',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSizes.xl),

                // ---- Continue Button ----
                CustomButton(
                  text: 'Continue',
                  onPressed: () => _onContinue(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
