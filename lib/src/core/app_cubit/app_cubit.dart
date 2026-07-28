import 'package:autobus_complete/src/core/app_cubit/app_state.dart';
import 'package:autobus_complete/src/core/helpers/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState(locale: Locale('ar')));

  static const String _kLanguageKey = 'app_language';

  Future<void> loadSettings() async {
    final savedLang = CacheStorage.read(_kLanguageKey) as String?;
    if (savedLang != null && savedLang.isNotEmpty) {
      emit(state.copyWith(locale: Locale(savedLang)));
    }
  }

  Future<void> changeLanguage(String langCode) async {
    if (state.locale.languageCode == langCode) return;
    await CacheStorage.write(_kLanguageKey, langCode);
    emit(state.copyWith(locale: Locale(langCode)));
  }

  Future<void> toggleLanguage() async {
    final nextLang = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(nextLang);
  }
}
