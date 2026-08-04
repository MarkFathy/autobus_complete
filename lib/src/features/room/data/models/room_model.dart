import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCategoryModel extends RoomCategoryEntity {
  const RoomCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.icon,
  });

  factory RoomCategoryModel.fromJson(Map<String, dynamic> json) => RoomCategoryModel(
      id: json['id']?.toString() ?? '',
      nameAr: json['nameAr'] as String? ?? json['name'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'icon': icon,
      };

  factory RoomCategoryModel.fromEntity(RoomCategoryEntity entity) => RoomCategoryModel(
      id: entity.id,
      nameAr: entity.nameAr,
      nameEn: entity.nameEn,
      icon: entity.icon,
    );
}

class RoomPlayerModel extends RoomPlayerEntity {
  const RoomPlayerModel({
    required super.id,
    required super.name,
    super.photoUrl,
    super.isHost = false,
    super.isReady = false,
    super.score = 0,
    super.lastSeen,
  });

  factory RoomPlayerModel.fromJson(Map<String, dynamic> json) => RoomPlayerModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      photoUrl: json['photoUrl'] as String?,
      isHost: (json['isHost'] as bool?) ?? false,
      isReady: (json['isReady'] as bool?) ?? false,
      score: (json['score'] as int?) ?? 0,
      lastSeen: json['lastSeen'] as int?,
    );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photoUrl': photoUrl,
        'isHost': isHost,
        'isReady': isReady,
        'score': score,
        'lastSeen': lastSeen,
      };

  factory RoomPlayerModel.fromEntity(RoomPlayerEntity entity) => RoomPlayerModel(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      isHost: entity.isHost,
      isReady: entity.isReady,
      score: entity.score,
      lastSeen: entity.lastSeen,
    );
}

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.roomCode,
    required super.hostId,
    required super.status,
    required super.rounds,
    required super.currentRound,
    required super.categories, required super.players, super.currentLetter,
    super.usedLetters = const [],
    super.roundAnswers = const {},
    super.roundScores = const {},
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final parsedAnswers = <String, Map<String, String>>{};
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

    final parsedScores = <String, Map<String, int>>{};
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

    final lastSeenMap = <String, int>{};
    if (json['lastSeenMap'] != null && json['lastSeenMap'] is Map) {
      (json['lastSeenMap'] as Map<String, dynamic>).forEach((key, val) {
        if (val is num) {
          lastSeenMap[key] = val.toInt();
        }
      });
    }

    final rawPlayersList = (json['players'] as List<dynamic>?) ?? [];
    final parsedPlayers = rawPlayersList.map((p) {
      final playerMap = Map<String, dynamic>.from(p as Map);
      final playerId = playerMap['id']?.toString() ?? '';
      if (lastSeenMap.containsKey(playerId)) {
        playerMap['lastSeen'] = lastSeenMap[playerId];
      }
      return RoomPlayerModel.fromJson(playerMap);
    }).toList();

    return RoomModel(
      roomCode: (json['roomCode'] as String?) ?? '',
      hostId: (json['hostId'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'waiting',
      rounds: (json['rounds'] as int?) ?? 5,
      currentRound: (json['currentRound'] as int?) ?? 1,
      currentLetter: json['currentLetter'] as String?,
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
      players: parsedPlayers,
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
