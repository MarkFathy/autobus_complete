
import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final int statusCode;
  final bool success;
  final String message;
  final List<String>? validationIssues;

  const ServerException(
    this.statusCode,
    this.success,
    this.message,
    this.validationIssues,
  );

  @override
  List<Object?> get props => [
    statusCode,
    success,
    message,
    validationIssues,
  ];
}

class FetchDataException extends ServerException {
  const FetchDataException(
    super.statusCode,
    super.success,
    super.message,
    super.validationIssues,
  );
}

class BadRequestException extends ServerException {
  const BadRequestException(
    super.statusCode,
    super.success,
    super.message,
    super.validationIssues,
  );
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(
    super.statusCode,
    super.success,
    super.message,
    super.validationIssues,
  );
}

class NotFoundException extends ServerException {
  const NotFoundException(
    super.statusCode,
    super.success,
    super.message,
    super.validationIssues,
  );
}

class ConflictException extends ServerException {
  const ConflictException(
    super.statusCode,
    super.success,
    super.message,
    super.validationIssues,
  );
}

// class InternalServerErrorException extends ServerException {
//   InternalServerErrorException([statusCode, success, message])
//     : super(500, false, LocaleKeys.checkInternet, [], null);
// }

// class NoInternetConnectionException extends ServerException {
//   NoInternetConnectionException([statusCode, success, message])
//     : super(500, false, LocaleKeys.checkInternet.tr(), [], null);
// }

class CacheException implements Exception {}
