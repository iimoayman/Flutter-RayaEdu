import 'package:dio/dio.dart';

import '../data/huaweiSessions.dart';
import '../data/order.dart';
import 'api_client.dart';
import 'supabase_config.dart';


class SupabaseService {
  Dio _client() {
    return Dio(
      BaseOptions(
        baseUrl: SupabaseConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          ...SupabaseConfig.headers,
        },
        validateStatus: (s) => s != null && s < 500,
      ),
    );
  }

  Future<List<Order>> fetchBanners() =>
      _fetchOrders('rest/v1/RayaBanners');

  Future<List<Order>> fetchGuestBanners() =>
      _fetchOrders('rest/v1/Guest');

  Future<List<Order>> fetchGuestBannersSecond() =>
      _fetchOrders('rest/v1/BanGuest');

  Future<List<Order>> _fetchOrders(String path) async {
    final res = await _client().get(
      path,
      queryParameters: {'select': '*', 'order': 'id.asc'},
    );

    if (res.statusCode == 200 && res.data is List) {
      return (res.data as List)
          .map((e) => Order.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    return [];
  }

  Future<List<HuaweiSession>> fetchHuaweiSessions() async {
    final res = await _client().get(
      'rest/v1/HuaweiSessions',
      queryParameters: {'select': 'link,title,instructor,Time'},
    );

    if (res.statusCode == 200 && res.data is List) {
      return (res.data as List)
          .map((e) =>
          HuaweiSession.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    return [];
  }
}