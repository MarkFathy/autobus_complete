import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';

extension ErrorHandler<T extends Object> on Future<T> {
  Future<Either<Failure, T>> handleCallbackWithFailure() async {
    try {
      final result = await this;
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e));
    } on Object catch (e) {
      return Left(Failure(ServerException(500, e.toString(), const [''])));
    }
  }
}
