import 'dart:io';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  });
  Future<Either<Failure, void>> sendPasswordResetEmail();
  Future<Either<Failure, void>> deleteAccount();
}
