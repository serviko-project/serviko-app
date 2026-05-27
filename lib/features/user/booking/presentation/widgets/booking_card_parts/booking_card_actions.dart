import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';

class BookingCardActions extends StatelessWidget {
  final BookingStatus status;
  final String paymentStatus;
  final String bookingId;
  final String serviceId;
  final bool hasReview;

  const BookingCardActions({
    super.key,
    required this.status,
    required this.paymentStatus,
    required this.bookingId,
    required this.serviceId,
    required this.hasReview,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    bool isPrimary = true;
    VoidCallback? onPressed;

    switch (status) {
      case BookingStatus.confirmed:
        final isPaid =
            paymentStatus.toLowerCase() == 'paid' ||
            paymentStatus.toLowerCase() == 'success';
        if (isPaid) {
          label = 'View Details';
          isPrimary = false;
        } else {
          label = 'Make Payment';
        }
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
        if (hasReview) {
          label = 'Book Again';
          isPrimary = true;
          onPressed = () {
            context.pushNamed(RouteNames.serviceDetails, extra: serviceId);
          };
        } else {
          label = 'Leave Review';
          onPressed = () {
            context.pushNamed(
              RouteNames.viewBooking,
              pathParameters: {'id': bookingId},
            );
          };
        }
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
      height: 40,
      borderRadius: AppSizes.radiusMd,
      onPressed: onPressed,
      isOutlined: !isPrimary,
    );
  }
}
