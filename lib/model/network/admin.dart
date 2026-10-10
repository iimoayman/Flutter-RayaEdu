import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_endpoints.dart';

class AdminService {
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
      ApiRoutes.adminLogin,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );


    final data = res.data;
    if (data is Map) return data.cast<String, dynamic>();
    return {'raw': data?.toString() ?? ''};
  }
}