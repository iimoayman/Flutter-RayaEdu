import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();


  static const String baseUrl =
      'https://gatestudent.rayaedu.org/studentgate/';

  static const String referer = 'https://gatestudent.rayaedu.org/';

  late final Dio dio;
  late final CookieJar cookieJar;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('${dir.path}/.cookies/'),
    );

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': referer,
        },
        // Let services inspect 4xx bodies (success:false / permission errors)
        // instead of Dio throwing.
        validateStatus: (s) => s != null && s < 500,
      ),
    );

    // CookieManager automatically attaches cookies from the jar to every
    // request AND saves Set-Cookie headers back into the jar.
    dio.interceptors.add(CookieManager(cookieJar));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }

    _initialized = true;
  }

  // ──────────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────────

  /// Builds `Cookie: csrftoken=...; sessionid=...` for image requests
  /// (used by `StudentAvatar` → `CachedNetworkImage.httpHeaders`).
  Future<String> buildCookieHeader() async {
    await init();
    final cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
    final parts = <String>[];
    for (final c in cookies) {
      if (c.name == 'csrftoken' || c.name == 'sessionid') {
        parts.add('${c.name}=${c.value}');
      }
    }
    return parts.join('; ');
  }

  /// Same shape as `buildCookieHeader` but for the *image* host
  /// (`student.rayaedu.org`), which lives on a different subdomain.
  Future<String> buildCookieHeaderForImages() async {
    await init();
    // Cookies were set on gatestudent.rayaedu.org — the image host is
    // student.rayaedu.org, so we read from the same jar regardless.
    final cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
    final parts = <String>[];
    for (final c in cookies) {
      if (c.name == 'csrftoken' || c.name == 'sessionid') {
        parts.add('${c.name}=${c.value}');
      }
    }
    return parts.join('; ');
  }

  /// Reads a single cookie value, or null.
  Future<String?> getCookie(String name) async {
    await init();
    final cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
    for (final c in cookies) {
      if (c.name == name) return c.value;
    }
    return null;
  }

  Future<void> clearCookies() async {
    await init();
    await cookieJar.deleteAll();
  }
}