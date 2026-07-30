import 'package:autobus_complete/src/features/settings/domain/entities/app_info_entity.dart';

class AppInfoModel extends AppInfoEntity {
  const AppInfoModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.contentAr,
    required super.contentEn,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json, String docId) {
    String getString(List<String> keys) {
      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null && json[key].toString().trim().isNotEmpty) {
          return json[key].toString().trim();
        }
      }
      return '';
    }

    return AppInfoModel(
      id: docId,
      titleAr: getString(['titleAr', 'title_ar', 'TitleAr', 'title']),
      titleEn: getString(['titleEn', 'title_en', 'TitleEn', 'title']),
      contentAr: getString(['contentAr', 'content_ar', 'ContentAr', 'aboutAr', 'about_ar', 'bodyAr', 'body_ar', 'descriptionAr', 'description_ar', 'detailsAr', 'details_ar', 'infoAr', 'info_ar', 'textAr', 'content']),
      contentEn: getString(['contentEn', 'content_en', 'ContentEn', 'aboutEn', 'about_en', 'bodyEn', 'body_en', 'descriptionEn', 'description_en', 'detailsEn', 'details_en', 'infoEn', 'info_en', 'textEn', 'content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titleAr': titleAr,
      'titleEn': titleEn,
      'contentAr': contentAr,
      'contentEn': contentEn,
    };
  }
}
