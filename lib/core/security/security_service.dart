import 'dart:io';
import 'package:safe_device/safe_device.dart';
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
    if (!Platform.isAndroid && !Platform.isIOS) {
      return SecurityCheckResult.passed;
    }

    try {
      final isJailBroken = await SafeDevice.isJailBroken;
      final isRealDevice = await SafeDevice.isRealDevice;
      final isMockLocation = await SafeDevice.isMockLocation;

      if (!isRealDevice || isMockLocation) {
        return SecurityCheckResult.clonedOrEmulator;
      }

      if (isJailBroken) {
        return SecurityCheckResult.rooted;
      }

      // Check common SU binary paths mirroring native SecCheckViewModel.kt
      final rootPaths = [
        '/system/app/Superuser.apk',
        '/sbin/su',
        '/system/bin/su',
        '/system/xbin/su',
        '/data/local/xbin/su',
        '/data/local/bin/su',
        '/system/sd/xbin/su',
        '/system/bin/failsafe/su',
        '/data/local/su',
      ];

      for (final path in rootPaths) {
        if (File(path).existsSync()) {
          return SecurityCheckResult.rooted;
        }
      }

      return SecurityCheckResult.passed;
    } catch (_) {
      return SecurityCheckResult.passed;
    }
  }
}
