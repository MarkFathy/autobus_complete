import 'dart:io';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

/// Emitted when registration succeeds and a verification email has been sent.
/// The UI should show a message and NOT navigate to the home screen.
class AuthEmailVerificationSent extends AuthState {
  final String message;
  const AuthEmailVerificationSent(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  final String message;
  const AuthPasswordResetSent(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthImagePicked extends AuthState {
  final File? image;
  const AuthImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class AuthImageRemoved extends AuthState {}
