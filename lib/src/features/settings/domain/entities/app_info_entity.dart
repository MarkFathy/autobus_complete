import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppInfoEntity extends Equatable {
  final String id;
  final String titleAr;
  final String titleEn;
  final String contentAr;
  final String contentEn;

  const AppInfoEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.contentAr,
    required this.contentEn,
  });

  String getLocalizedTitle(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? titleAr : titleEn;
  }

  String getLocalizedContent(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? contentAr : contentEn;
  }

  @override
  List<Object?> get props => [id, titleAr, titleEn, contentAr, contentEn];
}
