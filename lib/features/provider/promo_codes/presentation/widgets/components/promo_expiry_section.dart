import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/create_promo_form_cubit.dart';

class PromoExpirySection extends StatelessWidget {
  const PromoExpirySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePromoFormCubit, CreatePromoFormState>(
      builder: (context, formState) {
        return Row(
          children: [
            Expanded(
              child: Text(
                formState.expiresAt == null
                    ? "No Expiry Date Set"
                    : "Expires: ${DateFormat('dd MMM yyyy').format(formState.expiresAt!)}",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      formState.expiresAt ??
                      DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (!context.mounted) return;
                if (picked != null) {
                  context.read<CreatePromoFormCubit>().setExpiresAt(picked);
                }
              },
              child: Text(
                formState.expiresAt == null ? "Set Expiry" : "Change",
              ),
            ),
            if (formState.expiresAt != null)
              IconButton(
                icon: const Icon(Icons.clear, color: AppColors.error, size: 20),
                onPressed: () =>
                    context.read<CreatePromoFormCubit>().setExpiresAt(null),
              ),
          ],
        );
      },
    );
  }
}
