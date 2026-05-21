import 'package:equatable/equatable.dart';

/// Base Failure class for error handling in Clean Architecture
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Exception? exception;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.exception,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, exception, stackTrace];

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Cache failure - issues with local cache
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Database failure - issues with local database operations
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Network failure - issues with API calls (for future online features)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Scanner failure - issues with barcode/OCR scanning
class ScannerFailure extends Failure {
  const ScannerFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Validation failure - invalid input data
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Not found failure - requested resource doesn't exist
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code = 'NOT_FOUND',
    super.exception,
    super.stackTrace,
  });
}

/// Conflict failure - resource conflict (e.g., duplicate entry)
class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.code = 'CONFLICT',
    super.exception,
    super.stackTrace,
  });
}

/// Permission failure - missing required permissions
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code = 'PERMISSION_DENIED',
    super.exception,
    super.stackTrace,
  });
}

/// Notification failure - issues with notification services
class NotificationFailure extends Failure {
  const NotificationFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Unknown failure - unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code = 'UNKNOWN_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Server failure - backend API errors (for future online features)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code = 'SERVER_ERROR',
    super.exception,
    super.stackTrace,
  });
}

/// Timeout failure - operation timed out
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code = 'TIMEOUT',
    super.exception,
    super.stackTrace,
  });
}

/// Cancelled failure - operation was cancelled
class CancelledFailure extends Failure {
  const CancelledFailure({
    required super.message,
    super.code = 'CANCELLED',
    super.exception,
    super.stackTrace,
  });
}
