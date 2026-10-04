
class ApiRes<T> {
  final bool success;
  final List<String>? errors;
  final T? data;
  final String versionMobile;

  const ApiRes({
    required this.success,
    this.errors,
    this.data,
    required this.versionMobile,
  });

  factory ApiRes.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ApiRes<T>(
      success: json['success'] as bool? ?? false,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      versionMobile: json['versionMobile'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) => {
    'success': success,
    'errors': errors,
    'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
    'versionMobile': versionMobile,
  };
}

// ---------------------------------------------------------

class LoginRes {
  final bool success;
  final List<String>? errors;
  final dynamic data;

  const LoginRes({
    required this.success,
    this.errors,
    this.data,
  });

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
      success: json['success'] as bool? ?? false,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'errors': errors,
    'data': data,
  };
}