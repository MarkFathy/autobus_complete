import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/settings/domain/usecases/get_about_game_usecase.dart';
import 'package:autobus_complete/src/features/settings/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:autobus_complete/src/features/settings/presentation/cubit/app_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  final GetPrivacyPolicyUseCase getPrivacyPolicyUseCase;
  final GetAboutGameUseCase getAboutGameUseCase;

  AppInfoCubit({
    required this.getPrivacyPolicyUseCase,
    required this.getAboutGameUseCase,
  }) : super(AppInfoInitial());

  Future<void> loadPrivacyPolicy() async {
    final cached = getPrivacyPolicyUseCase.repository.getCachedPrivacyPolicy();
    if (cached != null) {
      emit(AppInfoLoaded(cached));
    } else {
      emit(AppInfoLoading());
    }
    final result = await getPrivacyPolicyUseCase(NoParams());
    result.fold(
      (failure) {
        if (state is! AppInfoLoaded) {
          emit(AppInfoError(failure.serverException.message));
        }
      },
      (info) => emit(AppInfoLoaded(info)),
    );
  }

  Future<void> loadAboutGame() async {
    final cached = getAboutGameUseCase.repository.getCachedAboutGame();
    if (cached != null) {
      emit(AppInfoLoaded(cached));
    } else {
      emit(AppInfoLoading());
    }
    final result = await getAboutGameUseCase(NoParams());
    result.fold(
      (failure) {
        if (state is! AppInfoLoaded) {
          emit(AppInfoError(failure.serverException.message));
        }
      },
      (info) => emit(AppInfoLoaded(info)),
    );
  }
}
