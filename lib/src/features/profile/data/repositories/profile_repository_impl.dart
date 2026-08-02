import 'dart:io';

import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:autobus_complete/src/features/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile() async {
    try {
      final profileModel = await remoteDataSource.getUserProfile();
      return Right(profileModel);
    } on Object catch (e) {
      debugPrint('[ProfileRepository.getUserProfile]: $e');
      return const Left(Failure(ServerException(0, 'Failed to load profile', null)));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  }) async {
    try {
      final profileModel = await remoteDataSource.updateProfile(
        name: name,
        email: email,
        imageFile: imageFile,
        removeImage: removeImage,
      );
      return Right(profileModel);
    } on Object catch (e) {
      debugPrint('[ProfileRepository.updateProfile]: $e');
      return const Left(Failure(ServerException(0, 'Failed to update profile', null)));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail() async {
    try {
      await remoteDataSource.sendPasswordResetEmail();
      return const Right(null);
    } on Object catch (e) {
      debugPrint('[ProfileRepository.sendPasswordResetEmail]: $e');
      return const Left(Failure(ServerException(0, 'Failed to send reset email', null)));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } on Object catch (e) {
      debugPrint('[ProfileRepository.deleteAccount]: $e');
      return const Left(Failure(ServerException(0, 'Failed to delete account', null)));
    }
  }
}
