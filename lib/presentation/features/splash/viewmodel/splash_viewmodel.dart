import 'package:flutter/foundation.dart';
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

    // Check Session & First Open
    final isFirst = await localDataSource.isFirstOpen();
    final sessionId = await localDataSource.getSessionId();

    if (!isFirst) {
      _destinationRoute = AppRoutes.onboarding;
    } else if (sessionId != null && sessionId.isNotEmpty) {
      _destinationRoute = AppRoutes.home;
    } else {
      _destinationRoute = AppRoutes.signIn;
    }

    _status = SplashStatus.securityPassed;
    notifyListeners();
  }
}
