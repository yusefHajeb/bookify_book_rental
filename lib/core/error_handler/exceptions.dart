/// Custom exceptions for the application
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred']);
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException([this.message = 'Database error occurred']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error occurred']);
}

class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException([this.message = 'Authentication failed']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Validation failed']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found']);
}

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission denied']);
}
