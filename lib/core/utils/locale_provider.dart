import 'package:flutter/material.dart';
import '../../data/datasources/local_datasource.dart';

class LocaleProvider with ChangeNotifier {
  final LocalDataSource localDataSource;
  Locale _locale = const Locale('ar');

  LocaleProvider(this.localDataSource) {
    _loadLocale();
  }

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> _loadLocale() async {
    final saved = await localDataSource.getLanguage();
    if (saved != null && (saved == 'ar' || saved == 'en')) {
      _locale = Locale(saved);
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await localDataSource.saveLanguage(languageCode);
    notifyListeners();
  }
}
