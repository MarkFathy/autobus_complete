import 'package:autobus_complete/src/features/settings/data/models/app_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppInfoRemoteDataSource {
  Future<AppInfoModel> getPrivacyPolicy();
  Future<AppInfoModel> getAboutGame();
}

class AppInfoRemoteDataSourceImpl implements AppInfoRemoteDataSource {
  final FirebaseFirestore firestore;

  AppInfoRemoteDataSourceImpl({required this.firestore});

  @override
  Future<AppInfoModel> getPrivacyPolicy() async {
    final doc = await firestore.collection('game_info').doc('privacy_policy').get();
    if (doc.exists && doc.data() != null) {
      return AppInfoModel.fromJson(doc.data()!, doc.id);
    }
    throw Exception('Privacy Policy document not found in game_info collection');
  }

  @override
  Future<AppInfoModel> getAboutGame() async {
    final doc = await firestore.collection('game_info').doc('about_game').get();
    if (doc.exists && doc.data() != null) {
      return AppInfoModel.fromJson(doc.data()!, doc.id);
    }
    throw Exception('About Game document not found in game_info collection');
  }
}
