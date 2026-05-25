import 'package:flutter/material.dart';

// App Colors
abstract final class AppColors {
  // ---- Brand ----
  static const Color primary = Color(0xFF6C3CE1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF5228B5);

  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF8F66);
  static const Color secondaryDark = Color(0xFFE55A27);

  // ---- Backgrounds ----
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F7FC);
  static const Color scaffoldBackground = Color(0xFFF8F7FC);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---- Borders & Dividers ----
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // ---- Status ----
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ---- Misc ----
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ---- For HomeScreen Categories ----
  static const List<Color> categoryPalette = [
    Color(0xFF9333EA),
    Color(0xFFEA580C),
    Color(0xFF0284C7),
    Color(0xFFD97706),
    Color(0xFFE11D48),
    Color(0xFF16A34A),
    Color(0xFF4F46E5),
    Color(0xFF0D9488),
    Color(0xFFDB2777),
    Color(0xFF0891B2),
    Color(0xFF65A30D),
    Color(0xFF4B5563),
  ];

  // ---- For Offer Cards ----
  static const List<Color> cardBackgrounds = [
    Color(0xFFECE7FF),
    Color(0xFFFFEBE3),
    Color(0xFFFFF3C4),
  ];
  static const List<Color> cardBorders = [
    Color(0xFFD1C4E9),
    Color(0xFFFFCCBC),
    Color(0xFFFFE082),
  ];
  static const List<Color> themeColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.warning,
  ];
}
