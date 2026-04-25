import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/otp_cubit.dart';
import 'package:serviko_app/features/user/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/injection_container.dart';

// OTP verification screen
class OtpVerificationScreen extends StatelessWidget {
  final OtpVerificationArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(
        verifyPhoneResetOtpUseCase:
            InjectionContainer.instance.verifyPhoneResetOtpUseCase,
        startPhoneResetOtpUseCase:
            InjectionContainer.instance.startPhoneResetOtpUseCase,
        initialSessionId: args.sessionId,
        initialCooldownSeconds: args.resendCooldownSeconds,
      ),
      child: _OtpView(args: args),
    );
  }
}

class _OtpView extends StatelessWidget {
  final OtpVerificationArgs args;

  const _OtpView({required this.args});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<OtpCubit, OtpState>(
        listenWhen: (previous, current) =>
            previous.error != current.error ||
            previous.verificationToken != current.verificationToken,
        listener: (context, state) {
          final cubit = context.read<OtpCubit>();

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

          final verificationToken = state.verificationToken;
          if (verificationToken != null && verificationToken.isNotEmpty) {
            context.pushNamed(
              AppRouter.createNewPassword,
              extra: CreateNewPasswordArgs(
                email: args.email,
                verificationToken: verificationToken,
              ),
            );
            cubit.clearVerificationToken();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xl),

                // ---- Back button ----
                BackButtonWidget(),
                const SizedBox(height: AppSizes.xl),

                // ---- Header ----
                Text(
                  'OTP Code Verification 📱',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'We sent an OTP to ${args.maskedPhone ?? 'your phone number'}. '
                  'Enter the code below to continue.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),

                // ---- OTP Input ----
                Center(
                  child: Pinput(
                    controller: cubit.otpController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: focusedPinTheme,
                    showCursor: true,
                    onCompleted: (_) => cubit.verifyOtp(email: args.email),
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // ---- Resend ----
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    return Center(
                      child: state.canResend
                          ? GestureDetector(
                              onTap: state.isResending
                                  ? null
                                  : () => cubit.resendOtp(email: args.email),
                              child: Text(
                                state.isResending
                                    ? 'Resending OTP...'
                                    : "Didn't receive code? Resend",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : Text(
                              'You can resend code in ${state.secondsRemaining}s',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.xxl),

                // ---- Verify Button ----
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Verify',
                      isLoading: state.isVerifying,
                      onPressed: state.isVerifying
                          ? null
                          : () => cubit.verifyOtp(email: args.email),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
