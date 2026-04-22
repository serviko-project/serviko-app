import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';

// Forgot password screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onSearchAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO : Check if account exists for the email, if not show error. If exists, navigate to choose reset method screen.
      context.pushNamed(
        AppRouter.chooseResetMethod,
        extra: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Form(
            key: _formKey,
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
                  controller: _emailController,
                  focusNode: _emailFocusNode,
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
                CustomButton(text: 'Continue', onPressed: _onSearchAccount),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
