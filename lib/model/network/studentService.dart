import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rayaedu/model/data/myData.dart';
import 'package:rayaedu/model/network/auth.dart';

class StudentService {
  static const String baseUrl =
      'https://gatestudent.rayaedu.org/studentgate/';

  final AuthService _auth = AuthService();

  Future<MyData> fetch({
    String mainTarget = 'platform',
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

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل بيانات الطالب (${response.statusCode})');
    }

    final Map<String, dynamic> body = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('لا توجد بيانات');
    }

    return MyData.fromJson(data);
  }
}