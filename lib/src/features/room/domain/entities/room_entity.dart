import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// A single game category (fetched from Firestore `categories` collection).
class RoomCategoryEntity extends Equatable {
  /// Firebase document ID (e.g. "boy", "girl")
  final String id;

  /// Arabic display name
  final String nameAr;

  /// English display name
  final String nameEn;

  /// Emoji icon
  final String icon;

  const RoomCategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
  });

  /// Returns the correct name based on the current app locale.
  String getLocalizedName(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? nameAr : nameEn;
  }

  /// Standard categories ordering across the app.
  static const List<String> categoryOrder = [
    'boy', 'girl', 'object', 'animal', 'plant', 'food', 'country'
  ];

  /// Central default categories fallback list.
  static const List<RoomCategoryEntity> defaultCategories = [
    RoomCategoryEntity(id: 'boy',     nameAr: 'ولد',   nameEn: 'Boy',     icon: '👦'),
    RoomCategoryEntity(id: 'girl',    nameAr: 'بنت',   nameEn: 'Girl',    icon: '👧'),
    RoomCategoryEntity(id: 'object',  nameAr: 'جماد',  nameEn: 'Object',  icon: '📦'),
    RoomCategoryEntity(id: 'animal',  nameAr: 'حيوان', nameEn: 'Animal',  icon: '🦁'),
    RoomCategoryEntity(id: 'plant',   nameAr: 'نبات',  nameEn: 'Plant',   icon: '🌿'),
    RoomCategoryEntity(id: 'food',    nameAr: 'أكلة',  nameEn: 'Food',    icon: '🍔'),
    RoomCategoryEntity(id: 'country', nameAr: 'بلد',   nameEn: 'Country', icon: '🚩'),
  ];

  /// Returns categories sorted by predefined categoryOrder, falling back to defaultCategories if empty.
  static List<RoomCategoryEntity> getOrderedCategories(List<RoomCategoryEntity>? input) {
    final list = (input == null || input.isEmpty) ? defaultCategories : input;
    return List<RoomCategoryEntity>.from(list)..sort((a, b) {
      final idxA = categoryOrder.indexOf(a.id);
      final idxB = categoryOrder.indexOf(b.id);
      return (idxA == -1 ? 999 : idxA).compareTo(idxB == -1 ? 999 : idxB);
    });
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn, icon];
}

class RoomPlayerEntity extends Equatable {
  final String id;
  final String name;
  final String? photoUrl;
  final bool isHost;
  final bool isReady;
  final int score;
  final int? lastSeen;

  const RoomPlayerEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isHost = false,
    this.isReady = false,
    this.score = 0,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [id, name, photoUrl, isHost, isReady, score, lastSeen];
}

class RoomEntity extends Equatable {
  final String roomCode;
  final String hostId;
  final String status;
  final int rounds;
  final int currentRound;
  final String? currentLetter;
  final List<String> usedLetters;
  final Map<String, Map<String, String>> roundAnswers;
  final Map<String, Map<String, int>> roundScores;
  final List<RoomCategoryEntity> categories;
  final List<RoomPlayerEntity> players;
  final int? updatedAt;
  final int? startTime;
  final int? targetStartTime;

  const RoomEntity({
    required this.roomCode,
    required this.hostId,
    required this.status,
    required this.rounds,
    required this.currentRound,
    required this.categories,
    required this.players,
    this.currentLetter,
    this.usedLetters = const [],
    this.roundAnswers = const {},
    this.roundScores = const {},
    this.updatedAt,
    this.startTime,
    this.targetStartTime,
  });

  @override
  List<Object?> get props => [
        roomCode,
        hostId,
        status,
        rounds,
        currentRound,
        currentLetter,
        usedLetters,
        roundAnswers,
        roundScores,
        categories,
        players,
        updatedAt,
        startTime,
        targetStartTime,
      ];
}
