import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Congratulations screen — shown after profile setup is complete.
class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

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

              // ---- Success animation ----
              LottieBuilder.asset(
                AppAssets.successAnimation,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: AppSizes.xxl),

              // ---- Title ----
              Text(
                'Congratulations! 🎉',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ---- Description ----
              Text(
                'Your account is ready to use.\nExplore the app and enjoy our services.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 3),

              // ---- Get Started Button ----
              CustomButton(
                text: 'Get Started',
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthProfileCompleted());
                },
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}
