import 'dart:io';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.forgotPasswordUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.serverException.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register(String name, String email, String password, {File? imageFile}) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      RegisterParams(name: name, email: email, password: password, imageFile: imageFile),
    );
    result.fold(
      (failure) {
        final msg = failure.serverException.message;
        if (msg.toLowerCase().contains('verification email sent') ||
            msg.contains('تفعيل')) {
          emit(AuthEmailVerificationSent(msg));
        } else {
          emit(AuthError(msg));
        }
      },
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    final result = await googleLoginUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.serverException.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthError(failure.serverException.message)),
      (_) => emit(AuthPasswordResetSent(S.current.passwordResetEmailSent)),
    );
  }

  File? selectedImage;

  Future<void> pickImage([ImageSource source = ImageSource.gallery]) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 60,
    );
    if (picked != null) {
      selectedImage = File(picked.path);
      emit(AuthImagePicked(selectedImage));
    }
  }

  void removeImage() {
    selectedImage = null;
    emit(AuthImageRemoved());
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.serverException.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
