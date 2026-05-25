import 'package:flutter/material.dart';

class PromoCardPainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final Color dashColor;

  PromoCardPainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.dashColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    const r = 12.0;
    const cutR = 8.0;
    final cutY = size.height * 0.5;

    // Start top-left
    path.moveTo(r, 0);
    // Top line
    path.lineTo(size.width - r, 0);
    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, r);
    // Right side top half
    path.lineTo(size.width, cutY - cutR);
    // Right cutout
    path.arcToPoint(
      Offset(size.width, cutY + cutR),
      radius: const Radius.circular(cutR),
      clockwise: false,
    );
    // Right side bottom half
    path.lineTo(size.width, size.height - r);
    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - r,
      size.height,
    );
    // Bottom line
    path.lineTo(r, size.height);
    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    // Left side bottom half
    path.lineTo(0, cutY + cutR);
    // Left cutout (arc inward)
    path.arcToPoint(
      Offset(0, cutY - cutR),
      radius: const Radius.circular(cutR),
      clockwise: false,
    );
    // Left side top half
    path.lineTo(0, r);
    // Top-left corner
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();

    // Draw background
    canvas.drawPath(path, paint);
    // Draw border
    canvas.drawPath(path, borderPaint);

    // Draw dashed divider
    final dividerX = size.width * 0.68;
    final dashPaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double startY = cutR;
    final endY = size.height - cutR;

    while (startY < endY) {
      canvas.drawLine(
        Offset(dividerX, startY),
        Offset(dividerX, startY + dashHeight),
        dashPaint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
