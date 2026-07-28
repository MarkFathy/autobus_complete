import 'dart:io';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password, File? imageFile});
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> logout();
}
