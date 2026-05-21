import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/date_time_utils.dart';
import 'package:serviko_app/core/utils/string_utils.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class ReceiptPdfService {
  // Generates a PDF receipt for the given booking and returns it as bytes
  static Future<Uint8List> build(BookingEntity booking) async {
    final document = pdf.Document();
    final transactionId = _transactionId(booking);

    document.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pdf.EdgeInsets.all(AppSizes.xl),
        build: (context) {
          return pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
              //  Header Section
              pdf.Text(
                'Serviko E-Receipt',
                style: pdf.TextStyle(
                  fontSize: 26,
                  fontWeight: pdf.FontWeight.bold,
                ),
              ),
              pdf.SizedBox(height: AppSizes.lg),
              _barcode(transactionId),
              pdf.SizedBox(height: AppSizes.lg),

              // Booking Details Section
              _section(
                children: [
                  _row('Category', booking.categoryName ?? 'Service'),
                  _row('Provider', booking.providerName ?? 'Provider'),
                  _row(
                    'Date & Time',
                    "${DateTimeUtils.formatDate(DateTime.parse(booking.scheduledDate))} | ${DateTimeUtils.formatTo12Hour(booking.startTime)}",
                  ),
                  _row('Working Hours', '${booking.durationHours} hours'),
                ],
              ),
              pdf.SizedBox(height: AppSizes.md),

              // Payment Details Section
              _section(
                children: [
                  _row(
                    'Amount',
                    'Rs. ${booking.totalPrice.toStringAsFixed(2)}',
                  ),
                  _row('Promo', 'Rs. 0.00'),
                  _row('Payment Method', 'Razorpay'),
                  _row(
                    'Payment Date',
                    DateTimeUtils.paymentDate(
                      booking.paidAt ?? booking.updatedAt,
                    ),
                  ),
                  _row('Transaction ID', transactionId),
                  _row(
                    'Status',
                    StringUtils.formatSnakeCase(booking.paymentStatus),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return document.save();
  }

  static pdf.Widget _section({required List<pdf.Widget> children}) {
    return pdf.Container(
      padding: const pdf.EdgeInsets.all(AppSizes.md),
      decoration: pdf.BoxDecoration(
        border: pdf.Border.all(color: PdfColors.grey300),
        borderRadius: pdf.BorderRadius.circular(12),
      ),
      child: pdf.Column(children: children),
    );
  }

  static pdf.Widget _row(String label, String value) {
    return pdf.Padding(
      padding: const pdf.EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: pdf.Row(
        mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pdf.CrossAxisAlignment.start,
        children: [
          pdf.Text(label, style: const pdf.TextStyle(color: PdfColors.grey700)),
          pdf.SizedBox(width: AppSizes.lg),
          pdf.Expanded(
            child: pdf.Text(
              value,
              textAlign: pdf.TextAlign.right,
              style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pdf.Widget _barcode(String value) {
    final bars = _bars(value);
    return pdf.Column(
      children: [
        pdf.Row(
          mainAxisAlignment: pdf.MainAxisAlignment.center,
          crossAxisAlignment: pdf.CrossAxisAlignment.end,
          children: bars
              .map(
                (width) => pdf.Container(
                  width: width.toDouble(),
                  height: AppSizes.xl * 2,
                  margin: const pdf.EdgeInsets.symmetric(horizontal: 2),
                  color: PdfColors.black,
                ),
              )
              .toList(),
        ),
        pdf.SizedBox(height: AppSizes.sm),
        pdf.Text(value, style: const pdf.TextStyle(fontSize: 11)),
      ],
    );
  }

  static List<int> _bars(String seed) {
    final codeUnits = seed.codeUnits;
    return List<int>.generate(54, (index) {
      final code = codeUnits[index % codeUnits.length];
      return (code + index) % 3 + 1;
    });
  }

  static String _transactionId(BookingEntity booking) {
    return booking.paymentReference ??
        booking.paymentId ??
        booking.id.replaceAll('-', '').substring(0, 12).toUpperCase();
  }
}
