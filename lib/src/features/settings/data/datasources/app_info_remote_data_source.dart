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
        return AppInfoModel.fromJson(cachedData, (cachedData['id'] as String?) ?? 'privacy_policy');
      } on Object catch (_) {}
    }
    return null;
  }

  @override
  AppInfoModel? getCachedAboutGame() {
    final cachedData = CacheStorage.read(_aboutKey, isDecoded: true);
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        return AppInfoModel.fromJson(cachedData, (cachedData['id'] as String?) ?? 'about_game');
      } on Object catch (_) {}
    }
    return null;
  }

  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map, String id) {
    final clean = <String, dynamic>{'id': id};
    map.forEach((k, v) {
      if (v is Timestamp) {
        clean[k] = v.toDate().toIso8601String();
      } else if (v is DateTime) {
        clean[k] = v.toIso8601String();
      } else if (v is String || v is num || v is bool || v == null) {
        clean[k] = v;
      } else {
        clean[k] = v.toString();
      }
    });
    return clean;
  }

  @override
  Future<AppInfoModel> getPrivacyPolicy() async {
    final cachedData = CacheStorage.read(_privacyKey, isDecoded: true);
    AppInfoModel? cachedModel;
    if (cachedData != null && cachedData is Map<String, dynamic>) {
      try {
        cachedModel = AppInfoModel.fromJson(cachedData, (cachedData['id'] as String?) ?? 'privacy_policy');
      } on Object catch (_) {}
    }

    try {
      final doc = await firestore.collection('game_info').doc('privacy_policy').get();
      if (doc.exists && doc.data() != null) {
        final model = AppInfoModel.fromJson(doc.data()!, doc.id);
        await CacheStorage.write(_privacyKey, _sanitizeMap(doc.data()!, doc.id));
        return model;
      }

      final query = await firestore.collection('game_info').where('type', isEqualTo: 'privacy_policy').limit(1).get();
      if (query.docs.isNotEmpty) {
        final model = AppInfoModel.fromJson(query.docs.first.data(), query.docs.first.id);
        await CacheStorage.write(_privacyKey, _sanitizeMap(query.docs.first.data(), query.docs.first.id));
        return model;
      }

      final allDocs = await firestore.collection('game_info').limit(5).get();
      for (final d in allDocs.docs) {
        if (d.id.contains('privacy') || (d.data()['type']?.toString().contains('privacy') ?? false)) {
          final model = AppInfoModel.fromJson(d.data(), d.id);
          await CacheStorage.write(_privacyKey, _sanitizeMap(d.data(), d.id));
          return model;
        }
      }
      if (allDocs.docs.isNotEmpty) {
        final model = AppInfoModel.fromJson(allDocs.docs.first.data(), allDocs.docs.first.id);
        await CacheStorage.write(_privacyKey, _sanitizeMap(allDocs.docs.first.data(), allDocs.docs.first.id));
        return model;
      }
    } catch (e) {
      // If network fails but we have cached content, safely return cachedModel
      if (cachedModel != null) {
        return cachedModel;
      }
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
        cachedModel = AppInfoModel.fromJson(cachedData, (cachedData['id'] as String?) ?? 'about_game');
      } on Object catch (_) {}
    }

    try {
      final doc = await firestore.collection('game_info').doc('about_game').get();
      if (doc.exists && doc.data() != null) {
        final model = AppInfoModel.fromJson(doc.data()!, doc.id);
        await CacheStorage.write(_aboutKey, _sanitizeMap(doc.data()!, doc.id));
        return model;
      }

      final query = await firestore.collection('game_info').where('type', isEqualTo: 'about_game').limit(1).get();
      if (query.docs.isNotEmpty) {
        final model = AppInfoModel.fromJson(query.docs.first.data(), query.docs.first.id);
        await CacheStorage.write(_aboutKey, _sanitizeMap(query.docs.first.data(), query.docs.first.id));
        return model;
      }

      final allDocs = await firestore.collection('game_info').limit(5).get();
      for (final d in allDocs.docs) {
        if (d.id.contains('about') || (d.data()['type']?.toString().contains('about') ?? false)) {
          final model = AppInfoModel.fromJson(d.data(), d.id);
          await CacheStorage.write(_aboutKey, _sanitizeMap(d.data(), d.id));
          return model;
        }
      }
      if (allDocs.docs.length > 1) {
        final model = AppInfoModel.fromJson(allDocs.docs[1].data(), allDocs.docs[1].id);
        await CacheStorage.write(_aboutKey, _sanitizeMap(allDocs.docs[1].data(), allDocs.docs[1].id));
        return model;
      } else if (allDocs.docs.isNotEmpty) {
        final model = AppInfoModel.fromJson(allDocs.docs.first.data(), allDocs.docs.first.id);
        await CacheStorage.write(_aboutKey, _sanitizeMap(allDocs.docs.first.data(), allDocs.docs.first.id));
        return model;
      }
    } catch (e) {
      // If network fails but we have cached content, safely return cachedModel
      if (cachedModel != null) {
        return cachedModel;
      }
      rethrow;
    }

    if (cachedModel != null) return cachedModel;
    throw Exception('About Game document not found in game_info collection');
  }
}
