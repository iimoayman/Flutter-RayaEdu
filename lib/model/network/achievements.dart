import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rayaedu/model/data/api_res.dart';
import 'package:rayaedu/model/data/studentAchievments.dart';
import 'package:rayaedu/model/network/auth.dart';

class AchievementsService {
  static const String baseUrl =
      'https://gatestudent.rayaedu.org/studentgate/';

  final AuthService _auth = AuthService();


  Future<StudentAchievements> fetch({
    String mainTarget = 'platformLeftHome',
  }) async {
    final cookie = await _auth.buildCookieHeader();

    final uri = Uri.parse('${baseUrl}app/').replace(
      queryParameters: {'main_target': mainTarget},
    );

    final response = await http.get(
      uri,
      headers: {
        'Referer': 'https://gatestudent.rayaedu.org/',
        'Accept': 'application/json',
        if (cookie.isNotEmpty) 'Cookie': cookie,
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('ليس لديك صلاحية توجه إلي الشئون');
    }

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل الإحصائيات (${response.statusCode})');
    }

    final Map<String, dynamic> body = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    final apiRes = ApiRes<StudentAchievements>.fromJson(
      body,
          (data) => StudentAchievements.fromJson(data),
    );

    if (!apiRes.success) {
      final msg = (apiRes.errors != null && apiRes.errors!.isNotEmpty)
          ? apiRes.errors!.first
          : 'فشل تحميل الإحصائيات';
      throw Exception(msg);
    }

    final data = apiRes.data;
    if (data == null) {
      throw Exception('لا توجد بيانات');
    }

    return data;
  }
}