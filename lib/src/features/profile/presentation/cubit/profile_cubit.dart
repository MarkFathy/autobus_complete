import 'dart:io';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/send_password_reset_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:autobus_complete/src/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final SendPasswordResetUseCase sendPasswordResetUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  File? selectedImage;
  bool isImageRemoved = false;
  UserEntity? currentUser;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.sendPasswordResetUseCase,
    required this.deleteAccountUseCase,
  }) : super(ProfileInitial());

  Future<void> getUserProfile() async {
    emit(ProfileLoading());
    final result = await getUserProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.serverException.message)),
      (user) {
        currentUser = user;
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> pickImage([ImageSource source = ImageSource.gallery]) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked != null) {
      selectedImage = File(picked.path);
      isImageRemoved = false;
      emit(ProfileImagePicked(selectedImage!));
    }
  }

  void removeImage() {
    selectedImage = null;
    isImageRemoved = true;
    emit(ProfileImageRemoved());
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(
      UpdateProfileParams(
        name: name,
        email: email,
        imageFile: selectedImage,
        removeImage: isImageRemoved,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(failure.serverException.message)),
      (updatedUser) {
        currentUser = updatedUser;
        selectedImage = null;
        isImageRemoved = false;
        emit(ProfileUpdateSuccess(updatedUser));
      },
    );
  }

  Future<void> sendPasswordResetEmail() async {
    emit(ProfileLoading());
    final result = await sendPasswordResetUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.serverException.message)),
      (_) => emit(ProfilePasswordResetSent(S.current.passwordResetEmailSent)),
    );
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    final result = await deleteAccountUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.serverException.message)),
      (_) => emit(ProfileAccountDeleted()),
    );
  }
}
