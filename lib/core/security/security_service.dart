import 'dart:io';
import 'package:screen_protector/screen_protector.dart';

enum SecurityCheckResult {
  passed,
  clonedOrEmulator,
  rooted,
}

class SecurityService {
  /// Enable screenshot prevention & data leakage protection (Android only)
  /// Screenshot prevention is explicitly disabled on iOS to allow taking screenshots
  static Future<void> enableScreenProtection() async {
    // Screenshot prevention explicitly disabled on iOS as requested
    if (Platform.isIOS) {
      try {
        await ScreenProtector.preventScreenshotOff();
        await ScreenProtector.protectDataLeakageOff();
      } catch (_) {}
      return;
    }
    if (!Platform.isAndroid) return;
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageOn();
    } catch (_) {}
  }

  /// Disable screenshot prevention
  static Future<void> disableScreenProtection() async {
    try {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageOff();
    } catch (_) {}
  }

  static Future<SecurityCheckResult> performCheck() async {
    return SecurityCheckResult.passed;
  }
}
