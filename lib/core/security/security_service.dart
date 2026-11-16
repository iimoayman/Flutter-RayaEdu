import 'dart:io';
import 'package:screen_protector/screen_protector.dart';

enum SecurityCheckResult {
  passed,
  clonedOrEmulator,
  rooted,
}

class SecurityService {
  /// Enable screenshot prevention & data leakage protection using screen_protector
  static Future<void> enableScreenProtection() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageOn();
    } catch (_) {}
  }

  /// Disable screenshot prevention
  static Future<void> disableScreenProtection() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageOff();
    } catch (_) {}
  }

  static Future<SecurityCheckResult> performCheck() async {
    return SecurityCheckResult.passed;
  }
}
