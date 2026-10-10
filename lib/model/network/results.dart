import '../data/api_res.dart';
import '../data/exam.dart';
import '../data/exam_result_dto.dart';
import '../data/results.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ResultsService {
  Future<ResultsResponse> fetchResults() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.results},
    );

    final apiRes = ApiRes<ResultsResponse>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
      (data) =>
          ResultsResponse.fromJson((data as Map).cast<String, dynamic>()),
    );

    if (apiRes.data == null) {
      throw Exception(apiRes.errors?.firstOrNull ?? 'No results');
    }
    return apiRes.data!;
  }

  Future<List<ExamInfo>> fetchRecords() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.studentMaterial},
    );

    final apiRes = ApiRes<List<ExamInfo>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
      (data) => (data as List)
          .map((e) => ExamInfo.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }

  Future<List<ExamResultDto>> fetchOnlineResults() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.resultsOnline},
    );

    final apiRes = ApiRes<List<ExamResultDto>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
      (data) => (data as List)
          .map((e) =>
              ExamResultDto.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }
}