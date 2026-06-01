import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralized text styles for the application
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Tech / OS Style Font (For Headers)
  static TextStyle get _techTextStyle => GoogleFonts.shareTechMono(
        color: AppColors.textPrimary,
        letterSpacing: 1.0,
      );

  // Modern UI Font (For Body Text)
  static TextStyle get _bodyTextStyle => GoogleFonts.outfit(
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  // Display styles
  static TextStyle get displayLarge => _techTextStyle.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        height: 1.12,
        color: AppColors.primary,
      );

  static TextStyle get displayMedium => _techTextStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        height: 1.16,
      );

  static TextStyle get displaySmall => _techTextStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        height: 1.22,
      );

  // Headline styles
  static TextStyle get headlineLarge => _techTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.25,
      );

  static TextStyle get headlineMedium => _techTextStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.29,
      );

  static TextStyle get headlineSmall => _techTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.33,
      );

  // Title styles
  static TextStyle get titleLarge => _bodyTextStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => _bodyTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.50,
      );

  static TextStyle get titleSmall => _bodyTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
      );

  // Body styles
  static TextStyle get bodyLarge => _bodyTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
      );

  static TextStyle get bodyMedium => _bodyTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
      );

  static TextStyle get bodySmall => _bodyTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
      );

  // Label styles
  static TextStyle get labelLarge => _techTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
      );

  static TextStyle get labelMedium => _techTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
      );

  static TextStyle get labelSmall => _techTextStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
      );

  // Custom styles
  static TextStyle get button => _techTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      );

  static TextStyle get caption => _bodyTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Helper method to get text theme
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
