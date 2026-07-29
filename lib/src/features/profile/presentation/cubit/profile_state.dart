import 'dart:io';
import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfilePasswordResetSent extends ProfileState {
  final String message;

  const ProfilePasswordResetSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileAccountDeleted extends ProfileState {}

class ProfileImagePicked extends ProfileState {
  final File image;

  const ProfileImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class ProfileImageRemoved extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
