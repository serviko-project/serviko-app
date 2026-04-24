import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:serviko_app/features/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/injection_container.dart';

// Forgot password screen
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  void _onSearchAccount(ForgotPasswordCubit cubit) =>
      cubit.checkRecoveryOptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (_) => ForgotPasswordCubit(
          forgotPasswordUseCase:
              InjectionContainer.instance.forgotPasswordUseCase,
          checkRecoveryOptionsUseCase:
              InjectionContainer.instance.checkRecoveryOptionsUseCase,
          startPhoneResetOtpUseCase:
              InjectionContainer.instance.startPhoneResetOtpUseCase,
        ),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            final cubit = context.read<ForgotPasswordCubit>();
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

            final options = state.recoveryOptions;
            if (options != null && options.accountExists) {
              context.pushNamed(
                AppRouter.chooseResetMethod,
                extra: ChooseResetMethodArgs(
                  email: options.email,
                  maskedEmail: options.maskedEmail,
                  hasPhoneRecovery: options.hasPhoneRecovery,
                  maskedPhone: options.maskedPhone,
                ),
              );
              cubit.clearRecoveryOptions();
            }
          },
          builder: (context, state) {
            final cubit = context.read<ForgotPasswordCubit>();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: Form(
                  key: cubit.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.xl),

                      // ---- Back button ----
                      const BackButtonWidget(),
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
                        'Enter your registered email address to find your account.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xxl),

                      // ---- Email field ----
                      CustomTextField(
                        hintText: 'Email',
                        controller: cubit.emailController,
                        focusNode: cubit.emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
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

                      const Spacer(),

                      // ---- Continue Button ----
                      CustomButton(
                        text: 'Continue',
                        isLoading: state.isLookupLoading,
                        onPressed: state.isLookupLoading
                            ? null
                            : () => _onSearchAccount(cubit),
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
}
