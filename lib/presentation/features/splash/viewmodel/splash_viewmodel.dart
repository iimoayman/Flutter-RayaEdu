import 'package:flutter/foundation.dart';
import '../../../../core/security/biometric_service.dart';
import '../../../../core/security/security_service.dart';
import '../../../../data/datasources/local_datasource.dart';
import '../../../navigation/app_routes.dart';

enum SplashStatus { loading, securityPassed, securityFailed }

class SplashViewModel with ChangeNotifier {
  final LocalDataSource localDataSource;

  SplashStatus _status = SplashStatus.loading;
  String? _errorMessage;
  String _destinationRoute = AppRoutes.onboarding;

  SplashViewModel(this.localDataSource);

  SplashStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get destinationRoute => _destinationRoute;

  Future<void> initApp() async {
    _status = SplashStatus.loading;
    notifyListeners();

    // 1. Root & Anti-Tamper check
    final secResult = await SecurityService.performCheck();
    if (secResult != SecurityCheckResult.passed) {
      _status = SplashStatus.securityFailed;
      _errorMessage = secResult == SecurityCheckResult.clonedOrEmulator
          ? 'cloning_app'
          : 'rooted_device';
      notifyListeners();
      return;
    }

    // 2. Check Session & First Open
    final isFirst = await localDataSource.isFirstOpen();
    final sessionId = await localDataSource.getSessionId();

    if (!isFirst) {
      _destinationRoute = AppRoutes.onboarding;
    } else if (sessionId != null && sessionId.isNotEmpty) {
      // Prompt biometric check like native MainActivity.kt
      final biometricSuccess = await BiometricService.authenticate();
      if (!biometricSuccess) {
        _status = SplashStatus.securityFailed;
        _errorMessage = 'unknown_error';
        notifyListeners();
        return;
      }
      _destinationRoute = AppRoutes.home;
    } else {
      _destinationRoute = AppRoutes.signIn;
    }

    _status = SplashStatus.securityPassed;
    notifyListeners();
  }
}
