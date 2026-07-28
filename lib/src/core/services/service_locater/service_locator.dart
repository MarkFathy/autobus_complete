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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';


final sl = GetIt.instance;

Future<void> init() async {
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
    () => AuthRepositoryImpl(remoteDataSource: sl()),
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

  
  // Cubit


  // Use cases

  // Repository

  // Data sources

  // Features - Game
  // Cubit
 
  // Use cases

  // Repository

  // Data sources

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
