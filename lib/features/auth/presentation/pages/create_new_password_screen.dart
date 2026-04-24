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
import 'package:serviko_app/features/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/injection_container.dart';

// Create new password screen
class CreateNewPasswordScreen extends StatelessWidget {
  final CreateNewPasswordArgs args;

  const CreateNewPasswordScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateNewPasswordCubit(
        resetPasswordWithPhoneOtpUseCase:
            InjectionContainer.instance.resetPasswordWithPhoneOtpUseCase,
      ),
      child: _CreateNewPasswordView(args: args),
    );
  }
}

class _CreateNewPasswordView extends StatelessWidget {
  final CreateNewPasswordArgs args;

  const _CreateNewPasswordView({required this.args});

  void _onContinue(BuildContext context) {
    final cubit = context.read<CreateNewPasswordCubit>();
    cubit.submitResetPassword(
      email: args.email,
      verificationToken: args.verificationToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateNewPasswordCubit>();

    return BlocListener<CreateNewPasswordCubit, CreateNewPasswordState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error || prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ),
            );
          cubit.clearError();
        }

        if (state.isSuccess) {
          context.goNamed(AppRouter.resetSuccess);
          cubit.clearSuccessFlag();
        }
      },
      child: Scaffold(
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
                  const SizedBox(height: AppSizes.xxl),

                  // ---- Continue Button ----
                  BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Continue',
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () => _onContinue(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
