import 'package:flutter/material.dart';

/// Centralized color palette for the application
/// Using semantic naming for better understanding and maintainability
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFFFFC107);
  static const Color primaryLight = Color(0xFFFFD54F);
  static const Color primaryDark = Color(0xFFF57C00);

  // Surface colors
  static const Color surface = Color(0xFF242430);
  static const Color surfaceDark = Color(0xFF191923);
  static const Color background = Color(0xFF1E1E28);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8B8B8D);
  static const Color textDisabled = Color(0xFF5A5A5C);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Additional colors
  static const Color divider = Color(0xFF3A3A3A);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x8A000000);

  // Material color swatch for primary color
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFFC107,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE082),
      300: Color(0xFFFFD54F),
      400: Color(0xFFFFCA28),
      500: primary,
      600: Color(0xFFFFB300),
      700: Color(0xFFFFA000),
      800: Color(0xFFFF8F00),
      900: Color(0xFFFF6F00),
    },
  );
}
