import '../data/api_res.dart';
import '../data/studentAchievments.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class AchievementsService {
  Future<StudentAchievements> fetch() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.platformLeftHome},
    );

    final apiRes = ApiRes<StudentAchievements>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => StudentAchievements.fromJson(
        (data as Map).cast<String, dynamic>(),
      ),
    );

    if (apiRes.data == null) {
      throw Exception(apiRes.errors?.firstOrNull ?? 'No achievements');
    }
    return apiRes.data!;
  }

  Future<StudentAchievements> refresh() => fetch();
}