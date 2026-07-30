import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/settings/domain/entities/app_info_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AppInfoRepository {
  Future<Either<Failure, AppInfoEntity>> getPrivacyPolicy();
  Future<Either<Failure, AppInfoEntity>> getAboutGame();
  AppInfoEntity? getCachedPrivacyPolicy();
  AppInfoEntity? getCachedAboutGame();
}
