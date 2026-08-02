import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
