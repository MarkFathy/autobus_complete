import 'dart:io';
import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:autobus_complete/src/features/profile/domain/repository/profile_repository.dart';
import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile() async {
    try {
      final profileModel = await remoteDataSource.getUserProfile();
      return Right(profileModel);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
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
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail() async {
    try {
      await remoteDataSource.sendPasswordResetEmail();
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }
}
