import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/presentation/services/download_receipt_service.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/e_receipt/details_tile.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/e_receipt/receipt_card.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/e_receipt/receipt_row.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/e_receipt/payment_status_row.dart';

// E-Receipt Screen
class EReceiptScreen extends StatelessWidget {
  final BookingEntity booking;

  const EReceiptScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final transactionId = _transactionId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'E-Receipt',
        actions: [
          IconButton(
            tooltip: 'Download receipt',
            icon: const Icon(Icons.download_rounded),
            onPressed: () =>
                DownloadReceiptService.downloadReceipt(context, booking),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: AppSizes.screenPadding,
          right: AppSizes.screenPadding,
          top: AppSizes.md,
          bottom: AppSizes.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.md),
            Center(
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    width: AppSizes.cardMinHeight,
                    height: AppSizes.cardMinHeight,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: AppSizes.iconXl,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  // Title & Amount
                  Text(
                    'Payment Successful',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Rs. ${booking.totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Booking Details Section
            ReceiptCard(
              children: [
                ReceiptRow(
                  label: 'Service',
                  value: booking.categoryName ?? 'Service Booking',
                ),
                ReceiptRow(
                  label: 'Workers',
                  value: booking.providerName ?? 'Provider',
                ),
                ReceiptRow(
                  label: 'Date & Time',
                  value:
                      "${DateTimeUtils.formatDate(DateTime.parse(booking.scheduledDate))} | ${DateTimeUtils.formatTo12Hour(booking.startTime)}",
                ),
                ReceiptRow(
                  label: 'Working Hours',
                  value: '${booking.durationHours} hours',
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            DetailsTile(
              title: 'Location Details',
              details: booking.customerAddress ?? 'No address provided',
            ),
            const SizedBox(height: AppSizes.md),

            // Payment Details Section
            ReceiptCard(
              children: [
                ReceiptRow(
                  label: 'Amount',
                  value: 'Rs. ${booking.totalPrice.toStringAsFixed(2)}',
                ),
                const ReceiptRow(
                  label: 'Promo',
                  value: 'Rs. 0.00',
                  valueColor: AppColors.primary,
                ),
                const ReceiptRow(label: 'Payment Methods', value: 'Razorpay'),
                ReceiptRow(
                  label: 'Date',
                  value: DateTimeUtils.paymentDate(
                    booking.paidAt ?? booking.updatedAt,
                  ),
                ),
                ReceiptRow(
                  label: 'Transaction ID',
                  value: transactionId,
                  trailing: IconButton(
                    tooltip: 'Copy transaction ID',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: AppColors.primary,
                      size: AppSizes.md,
                    ),
                    onPressed: () => _copyTransactionId(context, transactionId),
                  ),
                ),
                PaymentStatusRow(status: booking.paymentStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyTransactionId(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction ID copied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String get _transactionId {
    return booking.paymentReference ??
        booking.paymentId ??
        booking.id.replaceAll('-', '').substring(0, 10).toUpperCase();
  }
}
