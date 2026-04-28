import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/social_login_buttons.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:serviko_app/features/user/auth/presentation/widgets/forgot_password_section.dart';
import 'package:serviko_app/features/user/auth/presentation/widgets/or_divider_widget.dart';
import 'package:serviko_app/injection_container.dart';

// Sign-in screen
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignInCubit(signInUseCase: InjectionContainer.instance.signInUseCase),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();

    return BlocListener<SignInCubit, SignInState>(
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

        // Sign-in success
        if (state.user != null) {
          context.goNamed(AppRouter.home);
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
                    const SizedBox(height: AppSizes.lg),

                    // ---- App Logo ----
                    Image.asset(AppAssets.appLogo, width: 100, height: 100),
                    const SizedBox(height: AppSizes.lg + AppSizes.lg),

                    // ---- Header ----
                    Text(
                      'Welcome back 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Please enter your email & password to sign in.',
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
                      validator: FormValidators.validateEmail,
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
                      validator: FormValidators.validatePassword,
                    ),
                    const SizedBox(height: AppSizes.md),

                    // ---- Remember me + Forgot password ----
                    ForgotPasswordSection(cubit: cubit),

                    const SizedBox(height: AppSizes.lg),

                    // ---- Sign In Button ----
                    BlocBuilder<SignInCubit, SignInState>(
                      buildWhen: (prev, curr) =>
                          prev.isLoading != curr.isLoading,
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Sign In',
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () => cubit.signIn(),
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

                    // ---- Sign Up Link ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pushNamed(AppRouter.register),
                          child: Text(
                            'Sign up',
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
