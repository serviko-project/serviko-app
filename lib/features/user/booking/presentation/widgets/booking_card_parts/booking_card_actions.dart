import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class BookingCardActions extends StatelessWidget {
  final BookingStatus status;
  final String bookingId;
  final String serviceId;

  const BookingCardActions({
    super.key,
    required this.status,
    required this.bookingId,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    bool isPrimary = true;
    VoidCallback? onPressed;

    switch (status) {
      case BookingStatus.confirmed:
        label = 'Make Payment';
        onPressed = () {
          context.pushNamed(
            RouteNames.viewBooking,
            pathParameters: {'id': bookingId},
          );
        };
        break;
      case BookingStatus.pending:
        label = 'View Details';
        isPrimary = false;
        onPressed = () {
          context.pushNamed(
            RouteNames.viewBooking,
            pathParameters: {'id': bookingId},
          );
        };
        break;
      case BookingStatus.completed:
        label = 'Leave Review';
        onPressed = () {
          context.pushNamed(
            RouteNames.viewBooking,
            pathParameters: {'id': bookingId},
          );
        };
        break;
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
      case BookingStatus.expired:
        label = 'Book Again';
        onPressed = () {
          context.pushNamed(RouteNames.serviceDetails, extra: serviceId);
        };
        break;
    }

    return CustomButton(
      text: label,
      width: null,
      height: 40,
      borderRadius: AppSizes.radiusMd,
      onPressed: onPressed,
      isOutlined: !isPrimary,
    );
  }
}
