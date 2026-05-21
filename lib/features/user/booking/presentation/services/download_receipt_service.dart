import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/user/booking/presentation/services/receipt_pdf_service.dart';

class DownloadReceiptService {
  static Future<void> downloadReceipt(
    BuildContext context,
    BookingEntity booking,
  ) async {
    try {
      final bytes = await ReceiptPdfService.build(booking);
      final fileName = 'serviko_receipt_${_safeFileToken(booking.id)}.pdf';
      File? file;

      if (Platform.isAndroid) {
        try {
          final publicDir = Directory('/storage/emulated/0/Download');
          if (await publicDir.exists()) {
            final testFile = File(
              '${publicDir.path}${Platform.pathSeparator}$fileName',
            );
            await testFile.writeAsBytes(bytes, flush: true);
            file = testFile;
          }
        } catch (_) {}
      }

      if (file == null) {
        final directory = await _receiptDirectory();
        final testFile = File(
          '${directory.path}${Platform.pathSeparator}$fileName',
        );
        await testFile.writeAsBytes(bytes, flush: true);
        file = testFile;
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-receipt downloaded'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to generate receipt: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<Directory> _receiptDirectory() async {
    if (Platform.isAndroid) {
      final externalDirectory = await getExternalStorageDirectory();
      if (externalDirectory != null) return externalDirectory;
    }
    final downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) return downloadsDirectory;
    return getApplicationDocumentsDirectory();
  }

  static String _safeFileToken(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  }
}
