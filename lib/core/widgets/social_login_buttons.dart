import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';

// Social Login Buttons
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: AppAssets.googleIcon,
          onTap: () {
            // Login with Google
          },
        ),
        const SizedBox(width: AppSizes.lg),
        _SocialButton(
          icon: AppAssets.facebookIcon,
          onTap: () {
            // Login with Facebook
          },
        ),
        const SizedBox(width: AppSizes.lg),
        _SocialButton(
          icon: AppAssets.appleIcon,
          onTap: () {
            // Login with Apple
          },
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.5),
          color: AppColors.background,
        ),
        child: Image.asset(icon, width: 10, height: 10),
      ),
    );
  }
}
