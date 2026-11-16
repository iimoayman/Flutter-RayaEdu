import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized modern typography matching Cairo design standards for Raya Institute.
class AppTextStyles {
  static TextStyle cairoBlack({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle cairoExtraBold({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle cairoBold({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle cairoSemiBold({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle cairoMedium({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle cairoRegular({
    required double fontSize,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Pre-configured Semantic Text Styles
  static TextStyle headingLarge(BuildContext context) => cairoExtraBold(
        fontSize: 22,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.textDark,
      );

  static TextStyle headingMedium(BuildContext context) => cairoBold(
        fontSize: 18,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.textDark,
      );

  static TextStyle headingSmall(BuildContext context) => cairoBold(
        fontSize: 16,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.textDark,
      );

  static TextStyle bodyText(BuildContext context) => cairoMedium(
        fontSize: 14,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFCBD5E1)
            : AppColors.textSecondary,
      );

  static TextStyle caption(BuildContext context) => cairoRegular(
        fontSize: 12,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF94A3B8)
            : AppColors.textMuted,
      );
}
