import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_keys.dart';
import '../models/student_models.dart';

class LocalDataSource {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('LocalDataSource not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Session ID
  Future<void> saveSessionId(String sessionId) async {
    await _secureStorage.write(key: StorageKeys.sessionId, value: sessionId);
  }

  Future<String?> getSessionId() async {
    return await _secureStorage.read(key: StorageKeys.sessionId);
  }

  // CSRF Tokens
  Future<void> saveCsrfToken(String token) async {
    await _secureStorage.write(key: StorageKeys.csrfToken, value: token);
  }

  Future<String?> getCsrfToken([String? domain]) async {
    if (domain != null && domain.isNotEmpty) {
      final domainToken =
          await _secureStorage.read(key: '${StorageKeys.csrfPrefix}$domain');
      if (domainToken != null && domainToken.isNotEmpty) {
        return domainToken;
      }
    }
    return await _secureStorage.read(key: StorageKeys.csrfToken);
  }

  Future<void> saveDomainCsrfToken(String domain, String token) async {
    await _secureStorage.write(
        key: '${StorageKeys.csrfPrefix}$domain', value: token);
  }

  // Language
  Future<void> saveLanguage(String lang) async {
    await prefs.setString(StorageKeys.language, lang);
  }

  Future<String?> getLanguage() async {
    return prefs.getString(StorageKeys.language);
  }

  // Theme Mode
  Future<void> saveThemeMode(String mode) async {
    await prefs.setString(StorageKeys.themeMode, mode);
  }

  Future<String?> getThemeMode() async {
    return prefs.getString(StorageKeys.themeMode);
  }

  // Text Scaling
  Future<void> saveTextScale(double scale) async {
    await prefs.setDouble(StorageKeys.textScale, scale);
  }

  Future<double> getTextScale() async {
    return prefs.getDouble(StorageKeys.textScale) ?? 1.0;
  }

  // Primary Color
  Future<void> savePrimaryColor(String hex) async {
    await prefs.setString(StorageKeys.primaryColor, hex);
  }

  Future<String> getPrimaryColor(String defaultHex) async {
    return prefs.getString(StorageKeys.primaryColor) ?? defaultHex;
  }

  // Resume Token for Admission
  Future<void> saveResumeToken(String token) async {
    await _secureStorage.write(key: StorageKeys.resumeToken, value: token);
  }

  Future<String?> getResumeToken() async {
    return await _secureStorage.read(key: StorageKeys.resumeToken);
  }

  Future<void> clearResumeToken() async {
    await _secureStorage.delete(key: StorageKeys.resumeToken);
  }

  // First Open Flag
  Future<bool> isFirstOpen() async {
    return prefs.getBool(StorageKeys.isFirstOpen) ?? false;
  }

  Future<void> markFirstOpenDone() async {
    await prefs.setBool(StorageKeys.isFirstOpen, true);
  }

  // Student Applied Flag
  Future<void> setStudentApplied() async {
    await prefs.setBool(StorageKeys.studentApplied, true);
  }

  Future<bool> isStudentApplied() async {
    return prefs.getBool(StorageKeys.studentApplied) ?? false;
  }

  // Orders Cache
  Future<void> saveOrdersCache(List<Order> orders) async {
    final jsonStr = jsonEncode(orders.map((o) => o.toJson()).toList());
    await prefs.setString(StorageKeys.ordersCache, jsonStr);
    await prefs.setInt(
        StorageKeys.ordersLastUpdate, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Order>> getOrdersCache() async {
    final jsonStr = prefs.getString(StorageKeys.ordersCache);
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((item) => Order.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await prefs.clear();
  }
}
