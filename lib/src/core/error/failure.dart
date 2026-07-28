import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final ServerException serverException;

  const Failure(this.serverException);
  @override
  List<Object> get props => [serverException];
}

class ServerFailure extends Failure {
  const ServerFailure(super.serverException);

  @override
  List<Object> get props => [serverException];
}
