import 'package:custos/core/utils/device_type.dart';
import 'package:flutter/material.dart';

/// Centralized spacing scale for the entire app.
/// Only doubles are exposed — no EdgeInsets or Widgets —
/// so you can use them freely: padding, margin, SizedBox, borderRadius, etc.
///
/// Example:
///   padding: EdgeInsets.all(AppSpacing.md(context)),
///   height: AppSpacing.lg(context),
///   SizedBox(height: AppSpacing.sm(context)),
///
/// Scales auto‑adapt for mobile/tablet via screen width.
class AppSpacing {
  // Corners + calculated scale
  static const double baseCorner = 12.0; // modify once → everything scales
  static double corner(BuildContext context, [double factor = 1]) =>
      (DeviceInfo.isTablet(context)
          ? baseCorner * 1.2 * factor
          : baseCorner * factor);

  // Dialog max width (responsive)
  static const double baseDialogWidth = 500.0;
  static double dialogWidth(BuildContext context, [double factor = 1]) =>
      (DeviceInfo.isTablet(context)
          ? baseDialogWidth * 1.2 * factor
          : baseDialogWidth * factor);

  // Border side (responsive)
  static const double baseBorderWidth = 0.8;
  static double borderWidth(BuildContext context, [double factor = 1]) =>
      (DeviceInfo.isTablet(context)
          ? baseBorderWidth * 1.2 * factor
          : baseBorderWidth * factor);

  static const double baseMobile = 4; // 4px for phones
  static const double baseTablet = 6; // 6px for tablets

  static double _base(BuildContext context) {
    return DeviceInfo.isTablet(context) ? baseTablet : baseMobile;
  }

  // Semantic scale — readable and flexible
  // Short + extended aliases
  static double xs(BuildContext context) => _base(context) * 0.5; // 2/3
  static double s(BuildContext context) => _base(context) * 1; // 4/6
  static double sm(BuildContext context) => _base(context) * 1.5; // 6/9
  static double m(BuildContext context) => _base(context) * 2; // 8/12
  static double md(BuildContext context) => _base(context) * 2.5; // 10/15
  static double lg(BuildContext context) => _base(context) * 3; // 12/18
  static double xl(BuildContext context) => _base(context) * 4; // 16/24
  static double xxl(BuildContext context) => _base(context) * 5; // 20/30
  static double xxxl(BuildContext context) => _base(context) * 6; // 24/36
}

// =========================
// BuildContext extension
// =========================
extension AppSpacingExtension on BuildContext {
  // Spacing
  double get xs => AppSpacing.xs(this);
  double get s => AppSpacing.s(this);
  double get sm => AppSpacing.sm(this);
  double get m => AppSpacing.m(this);
  double get md => AppSpacing.md(this);
  double get lg => AppSpacing.lg(this);
  double get xl => AppSpacing.xl(this);
  double get xxl => AppSpacing.xxl(this);
  double get xxxl => AppSpacing.xxxl(this);

  /// Utility for non-standard spacing values while keeping everything derived
  /// from the centralized scale.
  ///
  /// Example: `context.space(4.5)` equals `18` on mobile (4 * 4.5) and `27` on
  /// tablet (6 * 4.5).
  double space(double units) => s * units;

  // Corners
  double corner([double factor = 1]) => AppSpacing.corner(this, factor);

  // Dialog width
  double dialogWidth() =>
      AppSpacing.dialogWidth(this);

  // Border width
  double border() => AppSpacing.borderWidth(this);
}
