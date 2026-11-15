import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../../data/datasources/local_datasource.dart';
import 'secure_cookie_manager.dart';

class ApiClient {
  final LocalDataSource localDataSource;
  late final Dio studentGateDio;
  late final Dio adminDio;
  late final Dio supabaseDio;

  ApiClient(this.localDataSource) {
    // 1. Student Gate Client
    studentGateDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.studentGateBaseUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Accept': 'application/json',
          'Referer': ApiEndpoints.studentGateReferer,
        },
      ),
    )..interceptors.add(SecureCookieInterceptor(localDataSource));

    // 2. Admin Client
    adminDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.adminBaseUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Accept': 'application/json',
          'Referer': ApiEndpoints.adminBaseUrl,
        },
      ),
    )..interceptors.add(SecureCookieInterceptor(localDataSource));

    // 3. Supabase REST Client
    supabaseDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.supabaseBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'apikey': ApiEndpoints.supabaseAnonKey,
          'Authorization': 'Bearer ${ApiEndpoints.supabaseAnonKey}',
        },
      ),
    );
  }
}
