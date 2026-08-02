import 'package:autobus_complete/src/core/helpers/cache_service.dart';
import 'package:autobus_complete/src/features/settings/data/models/app_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppInfoRemoteDataSource {
  Future<AppInfoModel> getPrivacyPolicy();
  Future<AppInfoModel> getAboutGame();
  AppInfoModel? getCachedPrivacyPolicy();
  AppInfoModel? getCachedAboutGame();
}

class AppInfoRemoteDataSourceImpl implements AppInfoRemoteDataSource {
  final FirebaseFirestore firestore;

  static const String _privacyKey = 'cached_privacy_policy';
  static const String _aboutKey = 'cached_about_game';

  AppInfoRemoteDataSourceImpl({required this.firestore});

  @override
  AppInfoModel? getCachedPrivacyPolicy() {
    final cachedData = CacheStorage.read(_privacyKey, isDecoded: true);
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        return AppInfoModel.fromJson(cachedData, cachedData['id'] ?? 'privacy_policy');
      } catch (_) {}
    }
    return null;
  }

  @override
  AppInfoModel? getCachedAboutGame() {
    final cachedData = CacheStorage.read(_aboutKey, isDecoded: true);
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        return AppInfoModel.fromJson(cachedData, cachedData['id'] ?? 'about_game');
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<AppInfoModel> getPrivacyPolicy() async {
    final cachedData = CacheStorage.read(_privacyKey, isDecoded: true);
    AppInfoModel? cachedModel;
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        cachedModel = AppInfoModel.fromJson(cachedData, cachedData['id'] ?? 'privacy_policy');
      } catch (_) {}
    }

    try {
      // 1. Check doc ID 'privacy_policy'
      final doc = await firestore.collection('game_info').doc('privacy_policy').get();
      if (doc.exists && doc.data() != null && doc.data()!['contentAr'] != null) {
        final model = AppInfoModel.fromJson(doc.data()!, doc.id);
        await CacheStorage.write(_privacyKey, {...doc.data()!, 'id': doc.id});
        return model;
      }

      // 2. Check doc ID 'privacy'
      final docPrivacy = await firestore.collection('game_info').doc('privacy').get();
      if (docPrivacy.exists && docPrivacy.data() != null && docPrivacy.data()!['contentAr'] != null) {
        final model = AppInfoModel.fromJson(docPrivacy.data()!, docPrivacy.id);
        await CacheStorage.write(_privacyKey, {...docPrivacy.data()!, 'id': docPrivacy.id});
        return model;
      }

      // 3. Query type or name containing privacy
      final allDocs = await firestore.collection('game_info').get();
      for (final d in allDocs.docs) {
        final idLower = d.id.toLowerCase();
        final typeLower = (d.data()['type']?.toString() ?? '').toLowerCase();
        if (idLower.contains('privacy') || typeLower.contains('privacy')) {
          final model = AppInfoModel.fromJson(d.data(), d.id);
          await CacheStorage.write(_privacyKey, {...d.data(), 'id': d.id});
          return model;
        }
      }
    } catch (_) {
      if (cachedModel != null) return cachedModel;
      rethrow;
    }

    if (cachedModel != null) return cachedModel;
    throw Exception('Privacy Policy document not found in game_info collection');
  }

  @override
  Future<AppInfoModel> getAboutGame() async {
    final cachedData = CacheStorage.read(_aboutKey, isDecoded: true);
    AppInfoModel? cachedModel;
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        cachedModel = AppInfoModel.fromJson(cachedData, cachedData['id'] ?? 'about_game');
      } catch (_) {}
    }

    try {
      // 1. Check doc ID 'about_game'
      final doc = await firestore.collection('game_info').doc('about_game').get();
      if (doc.exists && doc.data() != null && doc.data()!['contentAr'] != null) {
        final model = AppInfoModel.fromJson(doc.data()!, doc.id);
        await CacheStorage.write(_aboutKey, {...doc.data()!, 'id': doc.id});
        return model;
      }

      // 2. Check doc ID 'about'
      final docAbout = await firestore.collection('game_info').doc('about').get();
      if (docAbout.exists && docAbout.data() != null && docAbout.data()!['contentAr'] != null) {
        final model = AppInfoModel.fromJson(docAbout.data()!, docAbout.id);
        await CacheStorage.write(_aboutKey, {...docAbout.data()!, 'id': docAbout.id});
        return model;
      }

      // 3. Query type or name containing about
      final allDocs = await firestore.collection('game_info').get();
      for (final d in allDocs.docs) {
        final idLower = d.id.toLowerCase();
        final typeLower = (d.data()['type']?.toString() ?? '').toLowerCase();
        if (idLower.contains('about') || typeLower.contains('about')) {
          final model = AppInfoModel.fromJson(d.data(), d.id);
          await CacheStorage.write(_aboutKey, {...d.data(), 'id': d.id});
          return model;
        }
      }
    } catch (_) {
      if (cachedModel != null) return cachedModel;
      rethrow;
    }

    if (cachedModel != null) return cachedModel;
    throw Exception('About Game document not found in game_info collection');
  }
}
