/// Centralized dimensions for consistent spacing and sizing
/// Using flutter_screenutil for responsive values
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Padding values - responsive
  static double get paddingXS => 4;
  static double get paddingS => 8;
  static double get paddingM => 16;
  static double get paddingL => 20;
  static double get paddingXL => 24;
  static double get paddingXXL => 32;
  static double get paddingXXXL => 48;

  // Margin values - responsive
  static double get marginXS => 4;
  static double get marginS => 8;
  static double get marginM => 16;
  static double get marginL => 20;
  static double get marginXL => 24;
  static double get marginXXL => 32;

  // Border radius values - responsive
  static double get radiusXS => 4;
  static double get radiusS => 8;
  static double get radiusM => 12;
  static double get radiusL => 16;
  static double get radiusXL => 20;
  static double get radiusXXL => 24;
  static double get radiusCircular => 999;

  // Icon sizes - responsive
  static double get iconXS => 16;
  static double get iconS => 20;
  static double get iconM => 24;
  static double get iconL => 32;
  static double get iconXL => 48;

  // Button heights - responsive
  static double get buttonHeightS => 36;
  static double get buttonHeightM => 44;
  static double get buttonHeightL => 52;

  // AppBar height
  static double get appBarHeight => 56;

  // Bottom navigation height
  static double get bottomNavHeight => 60;

  // Card elevation
  static double get elevationXS => 1;
  static double get elevationS => 2;
  static double get elevationM => 4;
  static double get elevationL => 8;
  static double get elevationXL => 16;

  // Animation durations (in milliseconds)
  static const int animationFast = 200;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  static const int animationSlowHigh = 1200;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}