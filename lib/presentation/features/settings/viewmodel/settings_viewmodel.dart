import 'package:flutter/material.dart';
import '../../../../data/datasources/local_datasource.dart';

class SettingsViewModel with ChangeNotifier {
  final LocalDataSource localDataSource;

  bool _isDarkMode = false;
  bool _isBlueAccent = false;
  bool _notificationsEnabled = true;

  SettingsViewModel(this.localDataSource) {
    loadSettings();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isBlueAccent => _isBlueAccent;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    final mode = await localDataSource.getThemeMode();
    _isDarkMode = mode == 'dark';

    final colorHex = await localDataSource.getPrimaryColor('#005e39');
    _isBlueAccent = colorHex == '#0647ED';

    notifyListeners();
  }

  Future<void> toggleDarkMode(bool val) async {
    _isDarkMode = val;
    await localDataSource.saveThemeMode(val ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> toggleBlueAccent(bool val) async {
    _isBlueAccent = val;
    await localDataSource.savePrimaryColor(val ? '#0647ED' : '#005e39');
    notifyListeners();
  }

  void toggleNotifications(bool val) {
    _notificationsEnabled = val;
    notifyListeners();
  }
}
