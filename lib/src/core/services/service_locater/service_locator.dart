import 'package:autobus_complete/src/core/app_cubit/app_cubit.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:autobus_complete/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:autobus_complete/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/usecases/register_usecase.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autobus_complete/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:autobus_complete/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:autobus_complete/src/features/profile/domain/repository/profile_repository.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/send_password_reset_usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:autobus_complete/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:autobus_complete/src/features/room/data/datasources/room_remote_data_source.dart';
import 'package:autobus_complete/src/features/room/data/repositories/room_repository_impl.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/create_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/join_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/kick_player_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/leave_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/listen_to_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/make_host_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/toggle_ready_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_room_settings_usecase.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> init() async => await setupServiceLocator();

Future<void> setupServiceLocator() async {
  // App Cubit
  sl.registerLazySingleton(() => AppCubit());

  // Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      googleLoginUseCase: sl(),
      forgotPasswordUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      authLocalDataSource: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );

  // Features - Profile
  // Cubit
  sl.registerFactory(
    () => ProfileCubit(
      getUserProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      storage: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Features - Room
  // Cubit
  sl.registerLazySingleton(
    () => RoomCubit(
      createRoomUseCase: sl(),
      joinRoomUseCase: sl(),
      listenToRoomUseCase: sl(),
      toggleReadyUseCase: sl(),
      updateRoomSettingsUseCase: sl(),
      startGameUseCase: sl(),
      leaveRoomUseCase: sl(),
      makeHostUseCase: sl(),
      kickPlayerUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateRoomUseCase(sl()));
  sl.registerLazySingleton(() => JoinRoomUseCase(sl()));
  sl.registerLazySingleton(() => ListenToRoomUseCase(sl()));
  sl.registerLazySingleton(() => ToggleReadyUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRoomSettingsUseCase(sl()));
  sl.registerLazySingleton(() => StartGameUseCase(sl()));
  sl.registerLazySingleton(() => LeaveRoomUseCase(sl()));
  sl.registerLazySingleton(() => MakeHostUseCase(sl()));
  sl.registerLazySingleton(() => KickPlayerUseCase(sl()));

  // Repository
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
