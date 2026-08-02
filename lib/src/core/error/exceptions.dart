import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final int statusCode;
  final bool success;
  final String message;
  final List<String>? validationIssues;

  const ServerException(this.statusCode, this.message, this.validationIssues, {this.success = false});

  @override
  List<Object?> get props => [statusCode, success, message, validationIssues];
}

class FetchDataException extends ServerException {
  const FetchDataException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class BadRequestException extends ServerException {
  const BadRequestException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class NotFoundException extends ServerException {
  const NotFoundException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class ConflictException extends ServerException {
  const ConflictException(super.statusCode, super.message, super.validationIssues, {super.success});
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
