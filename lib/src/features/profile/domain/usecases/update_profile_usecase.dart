import 'dart:io';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/profile/domain/abstract_repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final String email;
  final File? imageFile;
  final bool removeImage;

  const UpdateProfileParams({
    required this.name,
    required this.email,
    this.imageFile,
    this.removeImage = false,
  });

  @override
  List<Object?> get props => [name, email, imageFile, removeImage];
}

class UpdateProfileUseCase implements BaseUseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      name: params.name,
      email: params.email,
      imageFile: params.imageFile,
      removeImage: params.removeImage,
    );
  }
}
