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

  const RoomPlayerEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isHost = false,
    this.isReady = false,
    this.score = 0,
  });

  @override
  List<Object?> get props => [id, name, photoUrl, isHost, isReady, score];
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

  const RoomEntity({
    required this.roomCode,
    required this.hostId,
    required this.status,
    required this.rounds,
    required this.currentRound,
    this.currentLetter,
    this.usedLetters = const [],
    this.roundAnswers = const {},
    this.roundScores = const {},
    required this.categories,
    required this.players,
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
      ];
}
