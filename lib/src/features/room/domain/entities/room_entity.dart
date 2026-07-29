import 'package:equatable/equatable.dart';

class RoomCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String icon;

  const RoomCategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
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
  final List<RoomCategoryEntity> categories;
  final List<RoomPlayerEntity> players;

  const RoomEntity({
    required this.roomCode,
    required this.hostId,
    required this.status,
    required this.rounds,
    required this.currentRound,
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
        categories,
        players,
      ];
}
