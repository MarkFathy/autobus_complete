import 'package:autobus_complete/src/core/app_cubit/app_cubit.dart';
import 'package:autobus_complete/src/core/services/notification_service.dart';
import 'package:autobus_complete/src/core/services/user_status_service.dart';
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
import 'package:autobus_complete/src/features/complaints/data/datasources/complaints_remote_data_source.dart';
import 'package:autobus_complete/src/features/complaints/data/repositories/complaints_repository_impl.dart';
import 'package:autobus_complete/src/features/complaints/domain/abstract_repository/complaints_repository.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/delete_complaint_usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/get_complaints_stream_usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/submit_complaint_usecase.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_cubit.dart';
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
import 'package:autobus_complete/src/features/room/domain/usecases/end_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/get_categories_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/join_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/kick_player_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/leave_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/listen_to_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/make_host_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/play_again_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_next_round_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/submit_round_answers_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/toggle_ready_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_category_score_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_room_settings_usecase.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/settings/data/datasources/app_info_remote_data_source.dart';
import 'package:autobus_complete/src/features/settings/data/repositories/app_info_repository_impl.dart';
import 'package:autobus_complete/src/features/settings/domain/abstract_repository/app_info_repository.dart';
import 'package:autobus_complete/src/features/settings/domain/usecases/get_about_game_usecase.dart';
import 'package:autobus_complete/src/features/settings/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:autobus_complete/src/features/settings/presentation/cubit/app_info_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> init() async => setupServiceLocator();

Future<void> setupServiceLocator() async {
  // App Cubit
  sl
    ..registerLazySingleton(AppCubit.new)
    // Features - Auth
    // Cubit
    ..registerFactory(
      () => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        googleLoginUseCase: sl(),
        forgotPasswordUseCase: sl(),
        logoutUseCase: sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => GoogleLoginUseCase(sl()))
    ..registerLazySingleton(() => ForgotPasswordUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    // Repository
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()))
    // Data sources
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        googleSignIn: sl(),
        authLocalDataSource: sl(),
        firestore: sl(),
      ),
    )
    // Features - Profile
    // Cubit
    ..registerFactory(
      () => ProfileCubit(
        getUserProfileUseCase: sl(),
        updateProfileUseCase: sl(),
        sendPasswordResetUseCase: sl(),
        deleteAccountUseCase: sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => GetUserProfileUseCase(sl()))
    ..registerLazySingleton(() => UpdateProfileUseCase(sl()))
    ..registerLazySingleton(() => SendPasswordResetUseCase(sl()))
    ..registerLazySingleton(() => DeleteAccountUseCase(sl()))
    // Repository
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: sl()))
    // Data sources
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl(), authLocalDataSource: sl()),
    )
    // Features - Room
    // Cubit
    ..registerLazySingleton(
      () => RoomCubit(
        getCategoriesUseCase: sl(),
        createRoomUseCase: sl(),
        joinRoomUseCase: sl(),
        listenToRoomUseCase: sl(),
        toggleReadyUseCase: sl(),
        updateRoomSettingsUseCase: sl(),
        startGameUseCase: sl(),
        playAgainUseCase: sl(),
        leaveRoomUseCase: sl(),
        makeHostUseCase: sl(),
        kickPlayerUseCase: sl(),
        startNextRoundUseCase: sl(),
        submitRoundAnswersUseCase: sl(),
        updateCategoryScoreUseCase: sl(),
        endGameUseCase: sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton(() => CreateRoomUseCase(sl()))
    ..registerLazySingleton(() => JoinRoomUseCase(sl()))
    ..registerLazySingleton(() => ListenToRoomUseCase(sl()))
    ..registerLazySingleton(() => ToggleReadyUseCase(sl()))
    ..registerLazySingleton(() => UpdateRoomSettingsUseCase(sl()))
    ..registerLazySingleton(() => StartGameUseCase(sl()))
    ..registerLazySingleton(() => PlayAgainUseCase(sl()))
    ..registerLazySingleton(() => LeaveRoomUseCase(sl()))
    ..registerLazySingleton(() => MakeHostUseCase(sl()))
    ..registerLazySingleton(() => KickPlayerUseCase(sl()))
    ..registerLazySingleton(() => StartNextRoundUseCase(sl()))
    ..registerLazySingleton(() => SubmitRoundAnswersUseCase(sl()))
    ..registerLazySingleton(() => UpdateCategoryScoreUseCase(sl()))
    ..registerLazySingleton(() => EndGameUseCase(sl()))
    // Repository
    ..registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(remoteDataSource: sl()))
    // Data sources
    ..registerLazySingleton<RoomRemoteDataSource>(() => RoomRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()))
    // AppInfo / Settings Feature
    ..registerFactory(() => AppInfoCubit(getPrivacyPolicyUseCase: sl(), getAboutGameUseCase: sl()))
    ..registerLazySingleton(() => GetPrivacyPolicyUseCase(sl()))
    ..registerLazySingleton(() => GetAboutGameUseCase(sl()))
    ..registerLazySingleton<AppInfoRepository>(() => AppInfoRepositoryImpl(remoteDataSource: sl()))
    ..registerLazySingleton<AppInfoRemoteDataSource>(() => AppInfoRemoteDataSourceImpl(firestore: sl()))
    // Complaints Feature
    ..registerFactory(
      () => ComplaintsCubit(
        submitComplaintUseCase: sl(),
        getComplaintsStreamUseCase: sl(),
        deleteComplaintUseCase: sl(),
        firebaseAuth: sl(),
        firestore: sl(),
      ),
    )
    ..registerLazySingleton(() => SubmitComplaintUseCase(sl()))
    ..registerLazySingleton(() => GetComplaintsStreamUseCase(sl()))
    ..registerLazySingleton(() => DeleteComplaintUseCase(sl()))
    ..registerLazySingleton<ComplaintsRepository>(() => ComplaintsRepositoryImpl(remoteDataSource: sl()))
    ..registerLazySingleton<ComplaintsRemoteDataSource>(() => ComplaintsRemoteDataSourceImpl(firestore: sl()))
    // Services
    ..registerLazySingleton(NotificationService.new)
    ..registerLazySingleton(
      () => UserStatusService(
        firebaseAuth: sl(),
        firestore: sl(),
        authLocalDataSource: sl(),
      ),
    )
    // External
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => GoogleSignIn.instance)
    ..registerLazySingleton(() => const FlutterSecureStorage());
}
