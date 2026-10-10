import '../data/api_res.dart';
import '../data/myData.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class StudentDataService {
  Future<MyData> fetch() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.home},
    );

    final apiRes = ApiRes<MyData>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => MyData.fromJson((data as Map).cast<String, dynamic>()),
    );

    if (apiRes.data == null) {
      throw Exception(apiRes.errors?.firstOrNull ?? 'No data');
    }
    return apiRes.data!;
  }

  Future<MyData> refresh() => fetch();
}