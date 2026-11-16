import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  /// Render native converted SVG icon
  static Widget svg(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      fit: fit,
    );
  }

  // Material fallback icons matching native XML shapes
  static const IconData home = Icons.home_rounded;
  static const IconData studentService = Icons.school_rounded;
  static const IconData exam = Icons.assignment_rounded;
  static const IconData results = Icons.fact_check_rounded;
  static const IconData onlineResults = Icons.laptop_chromebook_rounded;
  static const IconData records = Icons.history_edu_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData signOut = Icons.logout_rounded;
  static const IconData notification = Icons.notifications_active_rounded;
  static const IconData qr = Icons.qr_code_scanner_rounded;
  static const IconData backArrow = Icons.arrow_back_ios_new_rounded;
  static const IconData forwardArrow = Icons.arrow_forward_ios_rounded;
  static const IconData drawer = Icons.menu_rounded;
  static const IconData userGuide = Icons.menu_book_rounded;
  static const IconData newCard = Icons.credit_card_rounded;
  static const IconData proofOfRegistration = Icons.description_rounded;
  static const IconData statement = Icons.receipt_long_rounded;
  static const IconData check = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData wifiOff = Icons.wifi_off_rounded;
  static const IconData location = Icons.pin_drop_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData person = Icons.person_rounded;
  static const IconData chat = Icons.chat_rounded;
  static const IconData book = Icons.menu_book_rounded;
  static const IconData group = Icons.groups_rounded;
  static const IconData info = Icons.info_outline_rounded;
}
