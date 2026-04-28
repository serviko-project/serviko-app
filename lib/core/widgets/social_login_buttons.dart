import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/google_sign_in_cubit.dart';
import 'package:serviko_app/injection_container.dart';

// Social Login Buttons
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoogleSignInCubit(
        googleSignInUseCase: InjectionContainer.instance.googleSignInUseCase,
      ),
      child: const _SocialLoginView(),
    );
  }
}

class _SocialLoginView extends StatelessWidget {
  const _SocialLoginView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error || prev.user != curr.user,
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
          context.read<GoogleSignInCubit>().clearError();
        }

        // Google sign-in success
        if (state.user != null) {
          context.goNamed(AppRouter.fillProfile);
        }
      },
      child: BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
        buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialButton(
                icon: AppAssets.googleIcon,
                isLoading: state.isLoading,
                onTap: () {
                  context.read<GoogleSignInCubit>().signInWithGoogle();
                },
              ),
              const SizedBox(width: AppSizes.lg),
              _SocialButton(
                icon: AppAssets.facebookIcon,
                onTap: () {
                  // Facebook login
                },
              ),
              const SizedBox(width: AppSizes.lg),
              _SocialButton(
                icon: AppAssets.appleIcon,
                onTap: () {
                  // Apple login
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.5),
          color: AppColors.background,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Image.asset(icon, width: 10, height: 10),
      ),
    );
  }
}
