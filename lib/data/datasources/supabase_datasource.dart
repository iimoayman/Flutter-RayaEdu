import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/student_models.dart';

class SupabaseDataSource {
  final ApiClient apiClient;

  SupabaseDataSource(this.apiClient);

  Future<List<Order>> getRayaBanners() async {
    try {
      final response = await apiClient.supabaseDio.get(
        ApiEndpoints.rayaBanners,
        queryParameters: {'select': '*', 'order': 'id.asc'},
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => Order.fromJson(item)).toList();
    } catch (_) {
      return _getFallbackBanners();
    }
  }

  Future<List<Order>> getGuestBanners() async {
    try {
      final response = await apiClient.supabaseDio.get(
        ApiEndpoints.guestBanners,
        queryParameters: {'select': '*', 'order': 'id.asc'},
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => Order.fromJson(item)).toList();
    } catch (_) {
      return _getFallbackBanners();
    }
  }

  Future<List<Order>> getGuestBannersSecond() async {
    try {
      final response = await apiClient.supabaseDio.get(
        ApiEndpoints.guestBannersSecond,
        queryParameters: {'select': '*', 'order': 'id.asc'},
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => Order.fromJson(item)).toList();
    } catch (_) {
      return _getFallbackBanners();
    }
  }

  Future<List<HuaweiSession>> getHuaweiSessions() async {
    try {
      final response = await apiClient.supabaseDio.get(
        ApiEndpoints.huaweiSessions,
        queryParameters: {'select': 'link,title,instructor,Time'},
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => HuaweiSession.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  List<Order> _getFallbackBanners() {
    return [
      Order(id: 1, img: '', link: 'https://raya.edu.eg/'),
      Order(id: 2, img: '', link: 'https://raya.edu.eg/'),
      Order(id: 3, img: '', link: 'https://raya.edu.eg/'),
    ];
  }
}
