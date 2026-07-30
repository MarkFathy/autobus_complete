import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/settings/data/datasources/app_info_remote_data_source.dart';
import 'package:autobus_complete/src/features/settings/domain/abstract_repository/app_info_repository.dart';
import 'package:autobus_complete/src/features/settings/domain/entities/app_info_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  final AppInfoRemoteDataSource remoteDataSource;

  AppInfoRepositoryImpl({required this.remoteDataSource});

  @override
  AppInfoEntity? getCachedPrivacyPolicy() {
    return remoteDataSource.getCachedPrivacyPolicy();
  }

  @override
  AppInfoEntity? getCachedAboutGame() {
    return remoteDataSource.getCachedAboutGame();
  }

  @override
  Future<Either<Failure, AppInfoEntity>> getPrivacyPolicy() async {
    try {
      final result = await remoteDataSource.getPrivacyPolicy();
      return Right(result);
    } catch (e) {
      debugPrint('[AppInfoRepository.getPrivacyPolicy]: $e');
      return Left(ServerFailure(ServerException(500, false, 'Failed to load Privacy Policy', null)));
    }
  }

  @override
  Future<Either<Failure, AppInfoEntity>> getAboutGame() async {
    try {
      final result = await remoteDataSource.getAboutGame();
      return Right(result);
    } catch (e) {
      debugPrint('[AppInfoRepository.getAboutGame]: $e');
      return Left(ServerFailure(ServerException(500, false, 'Failed to load About Game', null)));
    }
  }
}
