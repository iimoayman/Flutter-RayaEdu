import 'package:dio/dio.dart';
import '../../data/datasources/local_datasource.dart';

class SecureCookieInterceptor extends Interceptor {
  final LocalDataSource localDataSource;

  SecureCookieInterceptor(this.localDataSource);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final domain = options.uri.host;
    final sessionId = await localDataSource.getSessionId();
    final csrfToken = (await localDataSource.getCsrfToken(domain)) ??
        (await localDataSource.getCsrfToken());

    final cookies = <String>[];
    if (sessionId != null && sessionId.isNotEmpty) {
      cookies.add('sessionid=$sessionId');
    }
    if (csrfToken != null && csrfToken.isNotEmpty) {
      cookies.add('csrftoken=$csrfToken');
      options.headers['X-CSRFToken'] = csrfToken;
    }

    if (cookies.isNotEmpty) {
      options.headers['Cookie'] = cookies.join('; ');
    }

    // Mirroring native RetrofitClient Referer header
    if (domain.contains('gatestudent.rayaedu.org')) {
      options.headers['Referer'] = 'https://gatestudent.rayaedu.org/';
    } else if (domain.contains('student.rayaedu.org')) {
      options.headers['Referer'] = 'https://student.rayaedu.org/';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _extractAndSaveCookies(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      _extractAndSaveCookies(err.response!);
      if (err.response?.statusCode == 401) {
        await localDataSource.clearAll();
      }
    }
    handler.next(err);
  }

  void _extractAndSaveCookies(Response response) async {
    final rawCookies = response.headers['set-cookie'];
    if (rawCookies != null) {
      final domain = response.requestOptions.uri.host;
      for (final cookie in rawCookies) {
        if (cookie.contains('sessionid=')) {
          final match = RegExp(r'sessionid=([^;]+)').firstMatch(cookie);
          if (match != null) {
            await localDataSource.saveSessionId(match.group(1)!);
          }
        }
        if (cookie.contains('csrftoken=')) {
          final match = RegExp(r'csrftoken=([^;]+)').firstMatch(cookie);
          if (match != null) {
            final token = match.group(1)!;
            await localDataSource.saveCsrfToken(token);
            await localDataSource.saveDomainCsrfToken(domain, token);
          }
        }
      }
    }
  }
}
