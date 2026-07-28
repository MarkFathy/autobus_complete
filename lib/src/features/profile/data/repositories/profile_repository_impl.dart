import 'dart:io';
import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:autobus_complete/src/features/profile/domain/abstract_repository/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final userModel = await remoteDataSource.getUserProfile();
      return Right(userModel);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        name: name,
        email: email,
        imageFile: imageFile,
        removeImage: removeImage,
      );
      return Right(userModel);
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
