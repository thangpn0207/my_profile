import 'package:flutter/material.dart';

/// Centralized color palette for the application
/// Using semantic naming for better understanding and maintainability
class AppColors {
  AppColors._();

  // --- Cyberpunk / Tech Yellows ---
  static const Color primary = Color(0xFFFFC107); // Pure Yellow
  static const Color accentYellow = Color(0xFFFFFF00); // Neon Yellow
  static const Color gold = Color(0xFFFFD700);
  static const Color lightYellow = Color(0xFFFFF176);
  static const Color glowYellow = Color(0x80FFC107); // 50% opacity primary

  // --- Deep Blacks & Grays (Tech Style) ---
  static const Color background = Color(0xFF0A0A0B); // Deep space black
  static const Color surface = Color(0xFF141417); // Slightly lighter dark
  static const Color surfaceDark = Color(0xFF0F0F12);
  static const Color cardBg = Color(0xFF1D1D21);

  // --- Gradients ---
  static const LinearGradient techGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFF57C00)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, background],
  );

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A5);
  static const Color textDisabled = Color(0xFF5A5A5C);

  // --- Status & Accent ---
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFD600);
  static const Color info = Color(0xFF00B0FF);

  // --- Borders & Dividers (Thin Tech Lines) ---
  static const Color divider = Color(0xFF2D2D33);
  static const Color glowBorder = Color(0x33FFC107);

  static final MaterialColor primarySwatch = MaterialColor(
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
