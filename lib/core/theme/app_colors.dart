import 'package:flutter/material.dart';

/// Raya Higher Institute (معهد راية العالي)
/// Brand Identity & Design System Color Palette
class AppColors {
  // ── Raya Primary Brand Colors (Emerald Green) ──────────────
  static const Color primary = Color(0xFF0F6B46);       // Deep Institutional Emerald
  static const Color primaryDark = Color(0xFF0A4D32);   // Dark Emerald
  static const Color primaryLight = Color(0xFF148556);  // Vibrant Emerald
  static const Color primaryAccent = Color(0xFF1FA66D); // Bright Mint Accent
  static const Color mintSurface = Color(0xFFF2F8F5);   // Soft Mint/Sage surface tint
  static const Color mintBorder = Color(0xFFD6EAE0);    // Subtle mint border

  // ── Raya Secondary Brand Colors (Vibrant Orange CTA) ────────
  static const Color orange = Color(0xFFF57C00);        // Primary CTA & Highlights
  static const Color orangeAccent = Color(0xFFFF8F00);  // Warm Radiant Orange
  static const Color orangeDark = Color(0xFFE65100);    // Deep Orange
  static const Color orangeLight = Color(0xFFFFF4E6);   // Soft Orange Tint
  static const Color orangeBorder = Color(0xFFFFE0B2);  // Soft Orange Border

  // ── Neutral & Semantic Colors ──────────────────────────────
  static const Color textDark = Color(0xFF1E293B);      // Slate Charcoal
  static const Color textSecondary = Color(0xFF475569); // Slate Muted
  static const Color textMuted = Color(0xFF64748B);     // Light Slate Subtitle
  static const Color textLight = Color(0xFF94A3B8);     // Very soft caption
  static const Color borderSubtle = Color(0xFFE2E8F0);  // Modern 1px card/divider border
  static const Color borderLight = Color(0xFFF1F5F9);   // Very soft border
  static const Color white = Color(0xFFFFFFFF);         // Pure Card White
  static const Color black = Color(0xFF0F172A);         // Deep Black
  static const Color translucent = Color(0x80FFFFFF);

  // ── Functional & Status Colors ─────────────────────────────
  static const Color gold = Color(0xFFD99B26);          // Honor / Award Gold
  static const Color blue = Color(0xFF2563EB);          // Informational Blue
  static const Color red = Color(0xFFDC2626);           // Error / Alert Red
  static const Color yellow = Color(0xFFF59E0B);        // Warning Amber
  static const Color whatsApp = Color(0xFF075E54);      // Official WhatsApp Green
  static const Color huawei = Color(0xFFC7000B);

  // ── Backward-compatible Aliases ────────────────────────────
  static const Color mainC = primary;
  static const Color darkGreen = primaryDark;
  static const Color lightGreen = primaryLight;
  static const Color gray0 = Color(0x1D1F2100);
  static const Color gray = Color(0x12333301);
  static const Color dGray = textDark;
  static const Color lightGray = textMuted;
  static const Color camC = Color(0x994E4E4E);
  static const Color hello = mintSurface;
  static const Color ico = Color(0xA0EDEDE4);

  // ── Theme Contextual (Light) ───────────────────────────────
  static const Color bgLight = Color(0xFFF8FAFC);       // Modern Off-White Surface
  static const Color bgColorLight = Color(0xFFF8FAFC);   // Background Surface
  static const Color cardLight = Color(0xFFFFFFFF);     // Pure White Card
  static const Color dialogLight = Color(0xFFFFFFFF);   // Dialog Surface
  static const Color icoOneLight = primary;
  static const Color icoFiveLight = primary;
  static const Color icoSixLight = primaryLight;
  static const Color icoSevenLight = primary;
  static const Color icoEightLight = orange;

  // ── Theme Contextual (Dark Mode) ───────────────────────────
  static const Color bgOneDark = Color(0xFF0F172A);     // Slate 900
  static const Color bgTwoDark = Color(0xFF1E293B);     // Slate 800
  static const Color bgThreeDark = Color(0xFF334155);   // Slate 700
  static const Color bgFourDark = Color(0xFF1E293B);
  static const Color bgColorDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color dialogDark = Color(0xFF1E293B);
  static const Color icoOneDark = Color(0xFF94A3B8);
  static const Color icoTwoDark = Color(0xFFFFFFFF);
  static const Color icoThreeDark = Color(0xA0EDEDE4);
  static const Color icoFourDark = Color(0xFFF1F5F9);
  static const Color icoFiveDark = orange;
  static const Color icoSixDark = orange;
  static const Color icoSevenDark = Color(0xFFFFFFFF);
  static const Color icoEightDark = primaryLight;

  // ── Modern Brand Gradients ─────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryLight],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primary, primaryLight],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange, orangeAccent],
  );

  static const LinearGradient mintCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), mintSurface],
  );
}
