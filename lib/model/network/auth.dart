import 'package:dio/dio.dart';

import 'api_client.dart';

class AuthService {

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await ApiClient.instance.init();

    final form = FormData.fromMap({
      'username': username,
      'password': password,
    });

    final res = await ApiClient.instance.dio.post(
      'login/',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    final body = _decode(res);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return body;
    }

    if (res.statusCode == 401 || res.statusCode == 403) {
      throw Exception('كود الطالب أو الرقم القومي غير صحيح');
    }

    final msg = (body['message'] != null)
        ? body['message'].toString()
        : 'حدث خطأ غير متوقع (${res.statusCode})';
    throw Exception(msg);
  }

  Future<bool> isTokenValid() async {
    await ApiClient.instance.init();

    final sid = await ApiClient.instance.getCookie('sessionid');
    if (sid == null || sid.isEmpty) return false;

    try {
      final res = await ApiClient.instance.dio.get('profile/');

      if (res.statusCode == 200) return true;

      if (res.statusCode == 401 || res.statusCode == 403) {
        await ApiClient.instance.clearCookies();
        return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<String> buildCookieHeader() =>
      ApiClient.instance.buildCookieHeader();

  Future<String> buildCookieHeaderForImages() =>
      ApiClient.instance.buildCookieHeaderForImages();

  Future<void> logout() => ApiClient.instance.clearCookies();

  Map<String, dynamic> _decode(Response res) {
    final data = res.data;
    if (data == null) return <String, dynamic>{};
    if (data is Map) return data.cast<String, dynamic>();
    return <String, dynamic>{'raw': data.toString()};
  }
}