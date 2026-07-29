import 'dart:io';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getUserProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  });
  Future<Either<Failure, void>> sendPasswordResetEmail();
  Future<Either<Failure, void>> deleteAccount();
}
