import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized modern UI styling, card decorations, shapes, and inputs for Raya Institute.
class AppDecorations {
  /// Primary elevated modern card (18-20dp rounded corners, delicate border & soft depth shadow)
  static BoxDecoration cardDecoration(
    BuildContext context, {
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
    bool hasShadow = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultRadius = borderRadius ?? BorderRadius.circular(20);
    final cardColor = color ?? (isDark ? AppColors.cardDark : AppColors.cardLight);

    return BoxDecoration(
      color: cardColor,
      borderRadius: defaultRadius,
      border: border ??
          Border.all(
            color: isDark ? const Color(0xFF334155) : AppColors.borderSubtle,
            width: 1.0,
          ),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : const Color(0xFF0F172A).withValues(alpha: 0.02),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ]
          : null,
    );
  }

  /// Modern Interactive Card with Brand Left/Right Accent Strip
  static BoxDecoration accentCardDecoration(
    BuildContext context, {
    Color accentColor = AppColors.primary,
    bool isRtl = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? const Color(0xFF334155) : AppColors.borderSubtle,
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.3 : 0.05),
          blurRadius: 14,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// Sculpted Modern Header with subtle curve and gradient
  static BoxDecoration headerDecoration({
    LinearGradient? gradient,
    double radius = 24.0,
  }) {
    return BoxDecoration(
      gradient: gradient ?? AppColors.headerGradient,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryDark.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  /// Rounded Sheet / Container Top (Used in bottom sheets and overlays)
  static BoxDecoration roundedTopContainer(BuildContext context, {double radius = 28.0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  /// Circular or Rounded Square Icon Container (for badges and leading icons)
  static BoxDecoration iconBoxDecoration({
    Color backgroundColor = AppColors.mintSurface,
    Color? borderColor = AppColors.mintBorder,
    double radius = 14.0,
    bool isCircle = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircle ? null : BorderRadius.circular(radius),
      border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
    );
  }

  /// Pill badge decoration (for tags, statuses, chips)
  static BoxDecoration pillDecoration({
    required Color color,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(999),
      border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
    );
  }

  /// Input field decoration (Used in Forms and Dialogs)
  static InputDecoration inputDecoration({
    required BuildContext context,
    required String hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = fillColor ?? (isDark ? AppColors.bgThreeDark : const Color(0xFFF8FAFC));

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(
        fontFamily: 'Cairo',
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        color: isDark ? const Color(0xFFCBD5E1) : AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: bg,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : AppColors.borderSubtle,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : AppColors.borderSubtle,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.red, width: 2.0),
      ),
    );
  }

  /// Progress Card decoration
  static BoxDecoration progressCardDecoration(BuildContext context) {
    return cardDecoration(context, borderRadius: BorderRadius.circular(18));
  }
}
