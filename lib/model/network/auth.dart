import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://gatestudent.rayaedu.org/studentgate/';

  static const String _tokenKey   = 'session_token';   // raw header (for isTokenValid)
  static const String _csrfKey    = 'csrf_token';      // ← new
  static const String _sessionKey = 'session_id';      // ← new

  // ── Storage ──────────────────────────────────────────────
  Future<void> _saveToken(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, cookie);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_csrfKey);
  }

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_csrfKey);
    await prefs.remove(_sessionKey);
  }

  // ── NEW: same shape as the Kotlin cookieHeader ───────────
  /// Returns "csrftoken=abc; sessionid=xyz" (or "" if none).
  Future<String> buildCookieHeader() async {
    final csrf = await getCsrfToken();
    final sid  = await getSessionId();
    return [
      if (csrf != null && csrf.isNotEmpty) 'csrftoken=$csrf',
      if (sid  != null && sid.isNotEmpty)  'sessionid=$sid',
    ].join('; ');
  }

  // ── NEW: parse Set-Cookie and store the two named cookies ─
  Future<void> _saveCookies(String setCookieHeader) async {
    final prefs = await SharedPreferences.getInstance();

    // A single "Set-Cookie" line often contains multiple cookies joined by ","
    final parts = setCookieHeader.split(RegExp(r',(?=[^;]+=)'));

    for (final part in parts) {
      final cookie = part.split(';').first.trim();
      if (cookie.startsWith('csrftoken=')) {
        await prefs.setString(_csrfKey, cookie.substring('csrftoken='.length));
      } else if (cookie.startsWith('sessionid=')) {
        await prefs.setString(_sessionKey, cookie.substring('sessionid='.length));
      }
    }
  }

  // ── login ────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('${baseUrl}login/');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Referer'] = 'https://gatestudent.rayaedu.org/'
      ..headers['Accept'] = 'application/json'
      ..fields['username'] = username
      ..fields['password'] = password;

    final streamed = await request.send().timeout(const Duration(seconds: 20));
    final response = await http.Response.fromStream(streamed);

    final dynamic body = response.bodyBytes.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        await _saveToken(setCookie);       // for isTokenValid
        await _saveCookies(setCookie);     // ← NEW: split for the image request
      }
      return Map<String, dynamic>.from(body as Map);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('كود الطالب أو الرقم القومي غير صحيح');
    }

    final msg = (body is Map && body['message'] != null)
        ? body['message'].toString()
        : 'حدث خطأ غير متوقع (${response.statusCode})';
    throw Exception(msg);
  }

  // ── isTokenValid — unchanged ─────────────────────────────
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;

    try {
      final uri = Uri.parse('${baseUrl}profile/');
      final response = await http.get(
        uri,
        headers: {
          'Referer': 'https://gatestudent.rayaedu.org/',
          'Accept': 'application/json',
          'Cookie': token,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) return true;
      if (response.statusCode == 401 || response.statusCode == 403) {
        await clearToken();
        return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}