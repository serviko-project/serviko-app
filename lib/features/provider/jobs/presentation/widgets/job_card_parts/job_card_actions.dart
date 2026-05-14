import 'package:flutter/material.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class JobCardActions extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isUpdating;

  const JobCardActions({
    super.key,
    required this.onAccept,
    required this.onReject,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isUpdating ? null : onReject,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isUpdating ? null : onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 0),
              minimumSize: const Size(0, 32),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }
}
