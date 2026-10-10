import 'package:dio/dio.dart';

import '../data/api_res.dart';
import '../data/stuServices.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class StudentServiceApi {
  Future<List<StuServices>> addService({
    required String service,
    required String mainTarget,
    required String addressed,
    required String notesStudent,
  }) async {
    await ApiClient.instance.init();

    final form = FormData.fromMap({
      'service': service,
      'main_target': mainTarget,
      'addressed': addressed,
      'notes_student': notesStudent,
    });

    final res = await ApiClient.instance.dio.post(
      ApiRoutes.app,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    final apiRes = ApiRes<List<StuServices>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => (data as List)
          .map((e) => StuServices.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }

  Future<List<StuServices>> fetchHistory() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.studentService},
    );

    final apiRes = ApiRes<List<StuServices>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => (data as List)
          .map((e) => StuServices.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }
}