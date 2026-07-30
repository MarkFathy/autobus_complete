import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/settings/domain/abstract_repository/app_info_repository.dart';
import 'package:autobus_complete/src/features/settings/domain/entities/app_info_entity.dart';
import 'package:dartz/dartz.dart';

class GetPrivacyPolicyUseCase implements BaseUseCase<AppInfoEntity, NoParams> {
  final AppInfoRepository repository;

  GetPrivacyPolicyUseCase(this.repository);

  @override
  Future<Either<Failure, AppInfoEntity>> call(NoParams params) async {
    return await repository.getPrivacyPolicy();
  }
}
