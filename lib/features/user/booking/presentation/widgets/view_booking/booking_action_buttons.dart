import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

class BookingActionButtons extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onCancel;
  final VoidCallback? onPayment;
  final VoidCallback? onReview;

  const BookingActionButtons({
    super.key,
    required this.booking,
    required this.onCancel,
    this.onPayment,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status;
    final isPaid = booking.paymentStatus == 'paid';

    switch (status) {
      case BookingStatus.pending:
        return _buildButton(
          label: 'Cancel Booking',
          onPressed: onCancel,
          isDestructive: true,
          isOutlined: true,
        );

      case BookingStatus.confirmed:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              label: isPaid ? 'View E-Receipt' : 'Make Payment',
              onPressed: isPaid
                  ? () => context.pushNamed(
                      RouteNames.eReceipt,
                      pathParameters: {'id': booking.id},
                      extra: booking,
                    )
                  : onPayment ?? () {},
              isOutlined: isPaid,
            ),
            const SizedBox(height: 12),
            _buildButton(
              label: 'Cancel Booking',
              onPressed: onCancel,
              isDestructive: true,
              isOutlined: true,
            ),
          ],
        );

      case BookingStatus.completed:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(label: 'Leave Review', onPressed: onReview ?? () {}),
            const SizedBox(height: 12),
            _buildButton(
              label: 'Book Again',
              onPressed: () => context.pushNamed(
                RouteNames.serviceDetails,
                extra: booking.serviceId,
              ),
              isOutlined: true,
            ),
          ],
        );

      case BookingStatus.rejected:
      case BookingStatus.cancelled:
      case BookingStatus.expired:
        return _buildButton(
          label: 'Book Again',
          onPressed: () => context.pushNamed(
            RouteNames.serviceDetails,
            extra: booking.serviceId,
          ),
        );
    }
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onPressed,
    bool isDestructive = false,
    bool isOutlined = false,
  }) {
    return CustomButton(
      text: label,
      width: null,
      onPressed: onPressed,
      isOutlined: isOutlined,
      backgroundColor: isDestructive && !isOutlined ? AppColors.error : null,
      textColor: isDestructive && isOutlined ? AppColors.error : null,
      borderColor: isDestructive && isOutlined ? AppColors.error : null,
    );
  }
}
