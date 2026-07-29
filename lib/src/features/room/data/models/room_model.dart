import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCategoryModel extends RoomCategoryEntity {
  const RoomCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory RoomCategoryModel.fromJson(Map<String, dynamic> json) {
    return RoomCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory RoomCategoryModel.fromEntity(RoomCategoryEntity entity) {
    return RoomCategoryModel(
      id: entity.id,
      name: entity.name,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'isHost': isHost,
      'isReady': isReady,
      'score': score,
    };
  }

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
    required super.categories,
    required super.players,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomCode: json['roomCode'] ?? '',
      hostId: json['hostId'] ?? '',
      status: json['status'] ?? 'waiting',
      rounds: json['rounds'] ?? 5,
      currentRound: json['currentRound'] ?? 1,
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

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'hostId': hostId,
      'status': status,
      'rounds': rounds,
      'currentRound': currentRound,
      'categories': categories
          .map((c) => RoomCategoryModel.fromEntity(c).toJson())
          .toList(),
      'players': players
          .map((p) => RoomPlayerModel.fromEntity(p).toJson())
          .toList(),
    };
  }

  factory RoomModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    return RoomModel.fromJson(data);
  }
}
