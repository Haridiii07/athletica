/// Custom exception classes for the Athletica app
/// These provide more specific error handling and better user experience

/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication-related exceptions (401, 403, expired tokens, etc.)
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common authentication errors
  factory AuthException.invalidCredentials() {
    return const AuthException(
      message:
          'Invalid email or password. Please check your credentials and try again.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.tokenExpired() {
    return const AuthException(
      message: 'Your session has expired. Please sign in again.',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthException.unauthorized() {
    return const AuthException(
      message: 'You are not authorized to access this resource.',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthException.accountLocked() {
    return const AuthException(
      message:
          'Your account has been temporarily locked. Please try again later or contact support.',
      code: 'ACCOUNT_LOCKED',
    );
  }

  factory AuthException.emailNotVerified() {
    return const AuthException(
      message: 'Please verify your email address before signing in.',
      code: 'EMAIL_NOT_VERIFIED',
    );
  }
}

/// Network-related exceptions (timeout, no connection, server errors)
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() =>
      'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common network errors
  factory NetworkException.noConnection() {
    return const NetworkException(
      message:
          'No internet connection. Please check your network settings and try again.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Request timed out. Please check your connection and try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError() {
    return const NetworkException(
      message: 'Server is currently unavailable. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }

  factory NetworkException.badGateway() {
    return const NetworkException(
      message:
          'Service temporarily unavailable. Please try again in a few minutes.',
      code: 'BAD_GATEWAY',
    );
  }
}

/// Validation-related exceptions (400, invalid input, missing fields)
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  });

  @override
  String toString() =>
      'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common validation errors
  factory ValidationException.invalidEmail() {
    return const ValidationException(
      message: 'Please enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationException.weakPassword() {
    return const ValidationException(
      message:
          'Password must be at least 8 characters long and contain letters and numbers.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationException.emailTaken() {
    return const ValidationException(
      message:
          'This email address is already registered. Please use a different email or try signing in.',
      code: 'EMAIL_TAKEN',
    );
  }

  factory ValidationException.phoneInvalid() {
    return const ValidationException(
      message: 'Please enter a valid phone number.',
      code: 'PHONE_INVALID',
    );
  }

  factory ValidationException.requiredField(String field) {
    return ValidationException(
      message: '$field is required.',
      code: 'REQUIRED_FIELD',
      details: {'field': field},
    );
  }

  factory ValidationException.fromFields(
      Map<String, List<String>> fieldErrors) {
    return ValidationException(
      message: 'Please fix the validation errors and try again.',
      code: 'VALIDATION_FAILED',
      fieldErrors: fieldErrors,
    );
  }
}

/// Business logic exceptions (quota exceeded, feature not available, etc.)
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() =>
      'BusinessException: $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common business logic errors
  factory BusinessException.clientLimitReached() {
    return const BusinessException(
      message:
          'You have reached the maximum number of clients for your subscription plan.',
      code: 'CLIENT_LIMIT_REACHED',
    );
  }

  factory BusinessException.planNotFound() {
    return const BusinessException(
      message: 'The requested plan could not be found.',
      code: 'PLAN_NOT_FOUND',
    );
  }

  factory BusinessException.subscriptionExpired() {
    return const BusinessException(
      message:
          'Your subscription has expired. Please upgrade to continue using premium features.',
      code: 'SUBSCRIPTION_EXPIRED',
    );
  }

  factory BusinessException.featureNotAvailable() {
    return const BusinessException(
      message:
          'This feature is not available in your current subscription plan.',
      code: 'FEATURE_NOT_AVAILABLE',
    );
  }
}

/// Data-related exceptions (not found, conflict, etc.)
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() =>
      'DataException: $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common data errors
  factory DataException.notFound(String resource) {
    return DataException(
      message: '$resource not found.',
      code: 'NOT_FOUND',
      details: {'resource': resource},
    );
  }

  factory DataException.conflict(String resource) {
    return DataException(
      message: '$resource already exists or conflicts with existing data.',
      code: 'CONFLICT',
      details: {'resource': resource},
    );
  }

  factory DataException.corruptedData() {
    return const DataException(
      message:
          'The data appears to be corrupted. Please try refreshing or contact support.',
      code: 'CORRUPTED_DATA',
    );
  }
}

/// External service exceptions (Google, Facebook, payment processors, etc.)
class ExternalServiceException extends AppException {
  final String service;

  const ExternalServiceException({
    required super.message,
    required this.service,
    super.code,
    super.details,
  });

  @override
  String toString() =>
      'ExternalServiceException($service): $message${code != null ? ' (Code: $code)' : ''}';

  /// Factory constructors for common external service errors
  factory ExternalServiceException.googleSignIn() {
    return const ExternalServiceException(
      message:
          'Google Sign-In is currently unavailable. Please try again or use email/password.',
      service: 'Google Sign-In',
      code: 'GOOGLE_SIGNIN_ERROR',
    );
  }

  factory ExternalServiceException.facebookSignIn() {
    return const ExternalServiceException(
      message:
          'Facebook Sign-In is currently unavailable. Please try again or use email/password.',
      service: 'Facebook Sign-In',
      code: 'FACEBOOK_SIGNIN_ERROR',
    );
  }

  factory ExternalServiceException.paymentProcessor() {
    return const ExternalServiceException(
      message:
          'Payment processing is currently unavailable. Please try again later.',
      service: 'Payment Processor',
      code: 'PAYMENT_ERROR',
    );
  }
}

/// Helper class to map HTTP status codes to appropriate exceptions
class ExceptionMapper {
  /// Maps HTTP status code and response data to appropriate custom exception
  static AppException mapFromResponse(int statusCode, dynamic responseData,
      {String? endpoint}) {
    final message = _extractMessage(responseData);
    final code = _extractCode(responseData);

    switch (statusCode) {
      case 400:
        return _handle400Error(message, code, responseData);
      case 401:
        return _handle401Error(message, code);
      case 403:
        return AuthException.unauthorized();
      case 404:
        return DataException.notFound(endpoint ?? 'Resource');
      case 409:
        return _handle409Error(message, code);
      case 422:
        return _handle422Error(responseData);
      case 429:
        return const NetworkException(
          message:
              'Too many requests. Please wait a moment before trying again.',
          code: 'RATE_LIMITED',
        );
      case 500:
        return NetworkException.serverError();
      case 502:
        return NetworkException.badGateway();
      case 503:
        return NetworkException.serverError();
      case 504:
        return NetworkException.timeout();
      default:
        return NetworkException(
          message: message ?? 'An unexpected error occurred. Please try again.',
          code: code ?? 'UNKNOWN_ERROR',
          details: {'statusCode': statusCode},
        );
    }
  }

  static String? _extractMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ??
          responseData['error'] ??
          responseData['detail'];
    }
    return null;
  }

  static String? _extractCode(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['code'] ?? responseData['error_code'];
    }
    return null;
  }

  static AppException _handle400Error(
      String? message, String? code, dynamic responseData) {
    // Check for specific validation errors
    if (message?.toLowerCase().contains('email') == true &&
        message?.toLowerCase().contains('invalid') == true) {
      return ValidationException.invalidEmail();
    }
    if (message?.toLowerCase().contains('password') == true &&
        message?.toLowerCase().contains('weak') == true) {
      return ValidationException.weakPassword();
    }
    if (message?.toLowerCase().contains('phone') == true &&
        message?.toLowerCase().contains('invalid') == true) {
      return ValidationException.phoneInvalid();
    }

    return ValidationException(
      message: message ??
          'Invalid request data. Please check your input and try again.',
      code: code ?? 'BAD_REQUEST',
      details: responseData,
    );
  }

  static AppException _handle401Error(String? message, String? code) {
    if (code == 'TOKEN_EXPIRED' ||
        message?.toLowerCase().contains('expired') == true) {
      return AuthException.tokenExpired();
    }
    if (code == 'INVALID_CREDENTIALS' ||
        message?.toLowerCase().contains('credential') == true) {
      return AuthException.invalidCredentials();
    }

    return AuthException(
      message:
          message ?? 'Authentication failed. Please check your credentials.',
      code: code ?? 'UNAUTHORIZED',
    );
  }

  static AppException _handle409Error(String? message, String? code) {
    if (message?.toLowerCase().contains('email') == true &&
        message?.toLowerCase().contains('exists') == true) {
      return ValidationException.emailTaken();
    }

    return DataException.conflict('Resource');
  }

  static AppException _handle422Error(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('errors')) {
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        final fieldErrors = <String, List<String>>{};
        errors.forEach((field, messages) {
          if (messages is List) {
            fieldErrors[field] = messages.cast<String>();
          }
        });
        return ValidationException.fromFields(fieldErrors);
      }
    }

    return const ValidationException(
      message: 'Validation failed. Please check your input and try again.',
      code: 'VALIDATION_ERROR',
    );
  }
}
