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
import 'package:serviko_app/features/auth/presentation/cubit/otp_cubit.dart';

// OTP verification screen
class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => OtpCubit(), child: _OtpView());
  }
}

class _OtpView extends StatelessWidget {
  const _OtpView();

  void _onVerify(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    if (cubit.otpController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete OTP')),
      );
      return;
    }

    context.pushNamed(AppRouter.createNewPassword);
  }

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
      body: SafeArea(
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
                'We have sent an OTP code to your number. '
                'Enter the OTP code below to verify.',
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
                  onCompleted: (pin) => _onVerify(context),
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ---- Resend ----
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  return Center(
                    child: state.canResend
                        ? GestureDetector(
                            onTap: cubit.resendOtp,
                            child: Text(
                              "Didn't receive code? Resend",
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
              CustomButton(text: 'Verify', onPressed: () => _onVerify(context)),
            ],
          ),
        ),
      ),
    );
  }
}
