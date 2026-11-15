import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck || isDeviceSupported;
  }

  static Future<bool> authenticate() async {
    try {
      final canAuth = await canAuthenticate();
      if (!canAuth) return true;

      return await _auth.authenticate(
        localizedReason: 'أدخل بصمتك لكي تتمكن من فتح التطبيق',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
