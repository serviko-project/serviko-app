import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:serviko_app/features/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/features/auth/presentation/widgets/reset_password_method_card.dart';
import 'package:serviko_app/injection_container.dart';

// Choose reset method screen
class ChooseResetMethodScreen extends StatelessWidget {
  final ChooseResetMethodArgs args;

  const ChooseResetMethodScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(
        forgotPasswordUseCase:
            InjectionContainer.instance.forgotPasswordUseCase,
        checkRecoveryOptionsUseCase:
            InjectionContainer.instance.checkRecoveryOptionsUseCase,
        startPhoneResetOtpUseCase:
            InjectionContainer.instance.startPhoneResetOtpUseCase,
      ),
      child: _ChooseResetMethodView(args: args),
    );
  }
}

class _ChooseResetMethodView extends StatelessWidget {
  final ChooseResetMethodArgs args;

  const _ChooseResetMethodView({required this.args});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error ||
          prev.isEmailSent != curr.isEmailSent ||
          prev.otpSession != curr.otpSession,
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
          cubit.clearError();
        }

        if (state.isEmailSent) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'Email Sent ✅',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Text(
                'A password reset link has been sent to ${args.email}. '
                'Please check your inbox and follow the instructions.',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    context.goNamed(AppRouter.login);
                    cubit.clearEmailSentFlag();
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final otpSession = state.otpSession;
        if (otpSession != null) {
          context.pushNamed(
            AppRouter.otpVerification,
            extra: OtpVerificationArgs(
              email: otpSession.email.isNotEmpty
                  ? otpSession.email
                  : args.email,
              maskedPhone: otpSession.maskedPhone ?? args.maskedPhone,
              sessionId: otpSession.sessionId,
              resendCooldownSeconds: otpSession.resendCooldownSeconds,
            ),
          );
          cubit.clearOtpSession();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.xl),

                    // ---- Back button ----
                    const BackButtonWidget(),
                    const SizedBox(height: AppSizes.xl),

                    // ---- Header ----
                    Text(
                      'Account Recovery 🔒',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'Select which contact details should we use to reset your password.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxl),

                    // ---- Method Cards ----
                    ResetPasswordMethodCard(
                      icon: Icons.email_rounded,
                      title: 'via Email',
                      subtitle: args.maskedEmail,
                      isSelected: state.selectedMethodIndex == 0,
                      onTap: () => cubit.updateSelectedMethod(0),
                    ),
                    if (args.hasPhoneRecovery) ...[
                      const SizedBox(height: AppSizes.md),
                      ResetPasswordMethodCard(
                        icon: Icons.sms_rounded,
                        title: 'via SMS',
                        subtitle: args.maskedPhone ?? 'Phone not available',
                        isSelected: state.selectedMethodIndex == 1,
                        onTap: () => cubit.updateSelectedMethod(1),
                      ),
                    ],

                    const Spacer(),

                    // ---- Continue Button ----
                    CustomButton(
                      text: 'Continue',
                      isLoading: state.isActionLoading,
                      onPressed: state.isActionLoading
                          ? null
                          : () {
                              final isSmsSelected =
                                  args.hasPhoneRecovery &&
                                  state.selectedMethodIndex == 1;

                              if (!isSmsSelected) {
                                cubit.sendResetEmailFor(args.email);
                              } else {
                                cubit.startPhoneResetOtp(args.email);
                              }
                            },
                    ),
                    const SizedBox(height: AppSizes.xl),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
