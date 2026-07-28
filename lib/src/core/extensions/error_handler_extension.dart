import 'package:dartz/dartz.dart';
import '../error/exceptions.dart';
import '../error/failure.dart';

extension ErrorHandler<T extends Object> on Future<T> {
  Future<Either<Failure, T>> handleCallbackWithFailure() async {
    try {
      final result = await this;
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e));
    } catch (e) {
      return Left(
        Failure(ServerException( 500,false, e.toString(),[''])));
    }
  }
}