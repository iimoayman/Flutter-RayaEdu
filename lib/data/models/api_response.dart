class ApiRes<T> {
  final bool success;
  final List<String>? errors;
  final T? data;
  final String versionMobile;

  ApiRes({
    required this.success,
    this.errors,
    this.data,
    required this.versionMobile,
  });

  factory ApiRes.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiRes<T>(
      success: json['success'] ?? false,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      versionMobile: json['versionMobile']?.toString() ?? '',
    );
  }
}

class LoginRes {
  final bool success;
  final List<String>? errors;
  final dynamic data;

  LoginRes({
    required this.success,
    this.errors,
    this.data,
  });

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
      success: json['success'] ?? false,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      data: json['data'],
    );
  }
}
