import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 2),

                      // Lottie Success Animation
                      Center(
                        child: Lottie.asset(
                          'assets/lottie/success_animation.json',
                          fit: BoxFit.contain,
                          width: 170,
                          height: 170,
                        ),
                      ),

                      const SizedBox(height: AppSizes.xl),

                      // Title
                      Text(
                        "Request Sent.!!",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: AppSizes.sm),

                      Text(
                        "Your booking request is pending confirmation",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: AppSizes.xxl),

                      // Details Container
                      Container(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          spacing: AppSizes.lg + AppSizes.sm,
                          children: [
                            _buildInfoRow(
                              icon: Icons.send_rounded,
                              title: "Request Submitted",
                              subtitle:
                                  "Your booking request has been shared with the provider.",
                            ),

                            _buildInfoRow(
                              icon: Icons.timer_outlined,
                              title: "Awaiting Confirmation",
                              subtitle:
                                  "The provider will respond within 3 hours.",
                            ),

                            _buildInfoRow(
                              icon: Icons.receipt_long_outlined,
                              title: "Track Booking",
                              subtitle:
                                  "You can monitor updates from the My Bookings section.",
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Action Buttons
                      CustomButton(
                        text: "View My Bookings",
                        onPressed: () => context.goNamed(RouteNames.booking),
                      ),
                      const SizedBox(height: AppSizes.md),
                      CustomButton(
                        text: "Back to Home",
                        isOutlined: true,
                        onPressed: () {
                          context.goNamed(RouteNames.home);
                        },
                      ),
                      const SizedBox(height: AppSizes.xl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
