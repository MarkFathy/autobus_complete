import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCategoryModel extends RoomCategoryEntity {
  const RoomCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.icon,
  });

  factory RoomCategoryModel.fromJson(Map<String, dynamic> json) {
    return RoomCategoryModel(
      id: json['id']?.toString() ?? '',
      nameAr: json['nameAr'] as String? ?? json['name'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'icon': icon,
      };

  factory RoomCategoryModel.fromEntity(RoomCategoryEntity entity) {
    return RoomCategoryModel(
      id: entity.id,
      nameAr: entity.nameAr,
      nameEn: entity.nameEn,
      icon: entity.icon,
    );
  }
}

class RoomPlayerModel extends RoomPlayerEntity {
  const RoomPlayerModel({
    required super.id,
    required super.name,
    super.photoUrl,
    super.isHost = false,
    super.isReady = false,
    super.score = 0,
  });

  factory RoomPlayerModel.fromJson(Map<String, dynamic> json) {
    return RoomPlayerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      isHost: json['isHost'] ?? false,
      isReady: json['isReady'] ?? false,
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photoUrl': photoUrl,
        'isHost': isHost,
        'isReady': isReady,
        'score': score,
      };

  factory RoomPlayerModel.fromEntity(RoomPlayerEntity entity) {
    return RoomPlayerModel(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      isHost: entity.isHost,
      isReady: entity.isReady,
      score: entity.score,
    );
  }
}

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.roomCode,
    required super.hostId,
    required super.status,
    required super.rounds,
    required super.currentRound,
    super.currentLetter,
    super.usedLetters = const [],
    super.roundAnswers = const {},
    super.roundScores = const {},
    required super.categories,
    required super.players,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, String>> parsedAnswers = {};
    if (json['roundAnswers'] != null && json['roundAnswers'] is Map) {
      (json['roundAnswers'] as Map<String, dynamic>).forEach((playerKey, val) {
        if (val is Map) {
          parsedAnswers[playerKey] = {};
          (val as Map<String, dynamic>).forEach((catKey, answerVal) {
            parsedAnswers[playerKey]![catKey] = answerVal.toString();
          });
        }
      });
    }

    final Map<String, Map<String, int>> parsedScores = {};
    if (json['roundScores'] != null && json['roundScores'] is Map) {
      (json['roundScores'] as Map<String, dynamic>).forEach((playerKey, val) {
        if (val is Map) {
          parsedScores[playerKey] = {};
          (val as Map<String, dynamic>).forEach((catKey, scoreVal) {
            parsedScores[playerKey]![catKey] = (scoreVal as num?)?.toInt() ?? 0;
          });
        }
      });
    }

    return RoomModel(
      roomCode: json['roomCode'] ?? '',
      hostId: json['hostId'] ?? '',
      status: json['status'] ?? 'waiting',
      rounds: json['rounds'] ?? 5,
      currentRound: json['currentRound'] ?? 1,
      currentLetter: json['currentLetter'],
      usedLetters: (json['usedLetters'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      roundAnswers: parsedAnswers,
      roundScores: parsedScores,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((c) => RoomCategoryModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => RoomPlayerModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'roomCode': roomCode,
        'hostId': hostId,
        'status': status,
        'rounds': rounds,
        'currentRound': currentRound,
        if (currentLetter != null) 'currentLetter': currentLetter,
        'usedLetters': usedLetters,
        'roundAnswers': roundAnswers,
        'roundScores': roundScores,
        'categories': categories
            .map((c) => RoomCategoryModel.fromEntity(c).toJson())
            .toList(),
        'players': players
            .map((p) => RoomPlayerModel.fromEntity(p).toJson())
            .toList(),
      };

  factory RoomModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) =>
      RoomModel.fromJson(snapshot.data() ?? {});
}
