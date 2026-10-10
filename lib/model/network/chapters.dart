import 'package:dio/dio.dart';

import '../data/api_res.dart';
import '../data/api_res.dart';
import '../data/portal_material.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ChapterService {
  Future<MainPortal> fetchChapterData({
    int? openMaterialPk,
    int? chapterPk,
  }) async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {
        'main_target': MainTarget.platformChapter,
        if (openMaterialPk != null) 'profesorMaterialPK': openMaterialPk,
        if (chapterPk != null) 'chapterPK': chapterPk,
      },
    );

    final apiRes = ApiRes<MainPortal>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => MainPortal.fromJson((data as Map).cast<String, dynamic>()),
    );

    if (apiRes.data == null) {
      throw Exception(apiRes.errors?.firstOrNull ?? 'No chapter data');
    }
    return apiRes.data!;
  }

  Future<LoginRes> submitAnswers({
    required String mainTarget,
    required String answersJson,
    required int chapterPk,
  }) async {
    await ApiClient.instance.init();

    final form = FormData.fromMap({
      'main_target': mainTarget,
      'answers': answersJson,
      'chapterPK': chapterPk.toString(),
    });

    final res = await ApiClient.instance.dio.post(
      ApiRoutes.app,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    return LoginRes.fromJson((res.data as Map).cast<String, dynamic>());
  }

  Future<LoginRes> completeChapter({
    required String mainTarget,
    required bool completeChapter,
    required int openMaterialPk,
    required int chapterPk,
  }) async {
    await ApiClient.instance.init();

    final form = FormData.fromMap({
      'main_target': mainTarget,
      'completeChapter': completeChapter.toString(),
      'openMaterialPK': openMaterialPk.toString(),
      'chapterPK': chapterPk.toString(),
    });

    final res = await ApiClient.instance.dio.post(
      ApiRoutes.app,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    return LoginRes.fromJson((res.data as Map).cast<String, dynamic>());
  }
}