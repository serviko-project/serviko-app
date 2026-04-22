import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:serviko_app/features/onboarding/presentation/widgets/dot_indicator.dart';
import 'package:serviko_app/features/onboarding/presentation/widgets/onboarding_page_widget.dart';

// Onboarding data
const _pages = [
  OnboardingPageData(
    animationPath: AppAssets.onboardingDiscover,
    title: 'Find Services Near You',
    description:
        'Easily discover reliable professionals in your area for all '
        'your needs — from home services to personal assistance — '
        'all in one place.',
  ),
  OnboardingPageData(
    animationPath: AppAssets.onboardingBooking,
    title: 'Quick & Hassle-Free Booking',
    description:
        'Schedule services in just a few taps. Choose your preferred '
        'time, chat with providers and manage everything seamlessly.',
  ),
  OnboardingPageData(
    animationPath: AppAssets.onboardingMessaging,
    title: 'Chat, Call & Get Things Done',
    description:
        'Communicate with service providers through chat, audio or '
        'video calls and enjoy smart recommendations powered by AI.',
  ),
];

// Onboarding Screen with PageView, Dot Indicator and Navigation Buttons
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  Future<void> _completeOnboarding(BuildContext context) async {
    context.read<AuthBloc>().add(const AuthOnboardingCompleted());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Pages ----
            Expanded(
              child: PageView.builder(
                controller: cubit.pageController,
                itemCount: _pages.length,
                onPageChanged: cubit.onPageChanged,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPageWidget(
                    animationWidget: Lottie.asset(
                      page.animationPath,
                      fit: BoxFit.contain,
                    ),
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // ---- Dot Indicator ----
            BlocBuilder<OnboardingCubit, int>(
              builder: (context, currentPage) {
                return DotIndicator(
                  itemCount: _pages.length,
                  currentIndex: currentPage,
                );
              },
            ),
            const SizedBox(height: AppSizes.xl),

            // ---- Buttons ----
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: BlocBuilder<OnboardingCubit, int>(
                builder: (context, currentPage) {
                  final isLastPage =
                      currentPage == OnboardingCubit.totalPages - 1;

                  return Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Skip',
                          isOutlined: true,
                          onPressed: () => _completeOnboarding(context),
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: CustomButton(
                          text: isLastPage ? 'Get Started' : 'Next',
                          onPressed: () {
                            if (isLastPage) {
                              _completeOnboarding(context);
                            } else {
                              cubit.nextPage();
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }
}
