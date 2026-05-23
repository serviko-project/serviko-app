import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Shows a dialog to optionally add a completion note before marking as done
Future<void> showCompletionDialog(
  BuildContext context,
  String bookingId,
  void Function(String bookingId, String? note) onConfirm,
) async {
  final result = await showDialog<String?>(
    context: context,
    builder: (ctx) => const _CompletionDialogWidget(),
  );

  if (result != null) {
    onConfirm(bookingId, result.isEmpty ? null : result);
  }
}

class _CompletionDialogWidget extends StatefulWidget {
  const _CompletionDialogWidget();

  @override
  State<_CompletionDialogWidget> createState() =>
      _CompletionDialogWidgetState();
}

class _CompletionDialogWidgetState extends State<_CompletionDialogWidget> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        0,
        AppSizes.lg,
        AppSizes.lg,
      ),
      title: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSizes.sm),
          Text('Complete Job', style: AppTextStyles.h3),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to mark this job as completed?',
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: AppSizes.md),

          TextField(
            controller: _noteController,
            maxLines: 5,
            maxLength: 500,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Add a completion note (optional)',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              contentPadding: const EdgeInsets.all(AppSizes.sm + 4),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                isOutlined: true,
                borderColor: AppColors.primary,
                textColor: AppColors.primary,
                borderRadius: AppSizes.radiusMd,
                height: 40,
                onPressed: () => Navigator.of(context).pop(null),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: CustomButton(
                text: 'Complete',
                backgroundColor: AppColors.success,
                textColor: Colors.white,
                borderRadius: AppSizes.radiusMd,
                height: 40,
                onPressed: () =>
                    Navigator.of(context).pop(_noteController.text.trim()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
