import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:serviko_app/features/auth/presentation/widgets/reset_password_method_card.dart';

// Forgot password screen
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  void _onContinue(BuildContext context) {
    // TODO: Send OTP via selected method with Firebase
    context.pushNamed(AppRouter.forgotPasswordOtp);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.xl),

              // ---- Back button ----
              BackButtonWidget(),
              const SizedBox(height: AppSizes.xl),

              // ---- Header ----
              Text(
                'Forgot Password 🔒',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'Select which contact details should we use to reset your password.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ---- Method Cards ----
              BlocBuilder<ForgotPasswordCubit, int>(
                builder: (context, selectedMethod) {
                  return Column(
                    children: [
                      ResetPasswordMethodCard(
                        icon: Icons.sms_outlined,
                        title: 'via SMS',
                        subtitle: '+1 (234) ***-**78',
                        isSelected: selectedMethod == 0,
                        onTap: () => cubit.selectMethod(0),
                      ),
                      const SizedBox(height: AppSizes.md),
                      ResetPasswordMethodCard(
                        icon: Icons.email_outlined,
                        title: 'via Email',
                        subtitle: 'and***@yourdomain.com',
                        isSelected: selectedMethod == 1,
                        onTap: () => cubit.selectMethod(1),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),

              // ---- Continue Button ----
              CustomButton(
                text: 'Continue',
                onPressed: () => _onContinue(context),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}
