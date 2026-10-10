import '../data/api_res.dart';
import '../data/notifications.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class NotificationService {
  Future<List<AppNotification>> fetchAlerts() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.platformNotification},
    );

    final apiRes = ApiRes<List<AppNotification>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
      (data) => (data as List)
          .map((e) =>
              AppNotification.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }

  Future<List<MyWarnings>> fetchWarnings() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.studentAlert},
    );

    final apiRes = ApiRes<List<MyWarnings>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
      (data) => (data as List)
          .map((e) => MyWarnings.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }
}