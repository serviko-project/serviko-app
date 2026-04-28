import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Success screen shown after password reset is complete.
class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ---- Success Icon ----
              LottieBuilder.asset(
                AppAssets.successAnimation,
                height: 180,
                width: 180,
              ),

              const SizedBox(height: AppSizes.xxl),

              // ---- Title ----
              Text(
                'Reset Password\nSuccessful!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ---- Description ----
              Text(
                'Your password has been updated.\n'
                'You can now log in with your new credentials.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 3),

              // ---- Back to Login Button ----
              CustomButton(
                text: 'Back to Login',
                onPressed: () => context.goNamed(AppRouter.login),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}
