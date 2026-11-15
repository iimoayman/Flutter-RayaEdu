class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class SessionExpiredException extends ApiException {
  SessionExpiredException() : super('Session expired. Please log in again.', 401);
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No Internet connection. Please check your network.'])
      : super(message);
}
