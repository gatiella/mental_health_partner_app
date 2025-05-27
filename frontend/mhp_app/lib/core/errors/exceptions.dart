class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({required this.message});
}

class ValidationException implements Exception {
  final String message;

  ValidationException({required this.message});
}

class AuthException implements Exception {
  final String message;

  const AuthException({
    required this.message,
  });

  @override
  String toString() => 'AuthException: $message';
}
