import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

// Single onboarding page
class OnboardingPageData {
  final String animationPath;
  final String title;
  final String description;

  const OnboardingPageData({
    required this.animationPath,
    required this.title,
    required this.description,
  });
}

// Widget for a single onboarding page.
class OnboardingPageWidget extends StatelessWidget {
  final Widget animationWidget;
  final String title;
  final String description;

  const OnboardingPageWidget({
    super.key,
    required this.animationWidget,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        children: [
          const Spacer(flex: 1),
          // ---- Animation ----
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: animationWidget,
          ),
          const Spacer(flex: 1),
          // ---- Title ----
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // ---- Description ----
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
