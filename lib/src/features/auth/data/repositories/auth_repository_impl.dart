import 'dart:io';
import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/helpers/firebase_error_handler.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            400,
            false,
            FirebaseErrorHandler.getAuthErrorMessage(e),
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            500,
            false,
            FirebaseErrorHandler.getExceptionMessage(e),
            null,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    File? imageFile,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        imageFile: imageFile,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            400,
            false,
            FirebaseErrorHandler.getAuthErrorMessage(e),
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            500,
            false,
            FirebaseErrorHandler.getExceptionMessage(e),
            null,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final user = await remoteDataSource.loginWithGoogle();
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            400,
            false,
            FirebaseErrorHandler.getAuthErrorMessage(e),
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            500,
            false,
            FirebaseErrorHandler.getExceptionMessage(e),
            null,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            400,
            false,
            FirebaseErrorHandler.getAuthErrorMessage(e),
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            500,
            false,
            FirebaseErrorHandler.getExceptionMessage(e),
            null,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            500,
            false,
            FirebaseErrorHandler.getExceptionMessage(e),
            null,
          ),
        ),
      );
    }
  }
}
