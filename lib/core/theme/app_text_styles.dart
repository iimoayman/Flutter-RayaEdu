import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle cairoBlack({
    required double fontSize,
    required Color color,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
    );
  }

  static TextStyle cairoExtraBold({
    required double fontSize,
    required Color color,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
    );
  }

  static TextStyle cairoBold({
    required double fontSize,
    required Color color,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle cairoMedium({
    required double fontSize,
    required Color color,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
