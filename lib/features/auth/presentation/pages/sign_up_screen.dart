import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/widgets/social_login_buttons.dart';
import 'package:serviko_app/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:serviko_app/features/auth/presentation/widgets/or_divider_widget.dart';
import 'package:serviko_app/features/auth/presentation/widgets/terms_check_box_widget.dart';
import 'package:serviko_app/injection_container.dart';

// Sign-up screen
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignUpCubit(signUpUseCase: InjectionContainer.instance.signUpUseCase),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  void _onSignUp(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    if (!(cubit.formKey.currentState?.validate() ?? false)) return;

    if (!cubit.state.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Conditions')),
      );
      return;
    }

    cubit.signUp();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();

    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error || prev.user != curr.user,
      listener: (context, state) {
        // Show error snackbar
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
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Form(
                key: cubit.formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSizes.md),

                    // ---- App Logo ----
                    Image.asset(AppAssets.appLogo, width: 100, height: 100),
                    const SizedBox(height: AppSizes.lg + AppSizes.lg),

                    // ---- Header ----
                    Text(
                      'Create Account 🎉',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Fill in your details to continue and get started.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxl),

                    // ---- Email ----
                    CustomTextField(
                      hintText: 'Email',
                      controller: cubit.emailController,
                      focusNode: cubit.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.md),

                    // ---- Password ----
                    CustomTextField(
                      hintText: 'Password',
                      controller: cubit.passwordController,
                      focusNode: cubit.passwordFocusNode,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
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
                    const SizedBox(height: AppSizes.lg + AppSizes.md),

                    // ---- Terms checkbox ----
                    TermsCheckBoxWidget(cubit: cubit),
                    const SizedBox(height: AppSizes.lg + AppSizes.sm),

                    // ---- Sign Up Button ----
                    BlocBuilder<SignUpCubit, SignUpState>(
                      buildWhen: (prev, curr) =>
                          prev.isLoading != curr.isLoading,
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Sign Up',
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () => _onSignUp(context),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ---- Divider ----
                    OrDividerWidget(),
                    const SizedBox(height: AppSizes.lg),

                    // ---- Social Login ----
                    const SocialLoginButtons(),
                    const SizedBox(height: AppSizes.xl),

                    // ---- Sign In Link ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
