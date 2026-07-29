import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomCreatedSuccess extends RoomState {
  final String roomCode;

  const RoomCreatedSuccess(this.roomCode);

  @override
  List<Object?> get props => [roomCode];
}

class RoomJoinedSuccess extends RoomState {
  final String roomCode;

  const RoomJoinedSuccess(this.roomCode);

  @override
  List<Object?> get props => [roomCode];
}

class RoomUpdated extends RoomState {
  final RoomEntity room;

  const RoomUpdated(this.room);

  @override
  List<Object?> get props => [room];
}

class RoomGameStarted extends RoomState {
  final RoomEntity room;

  const RoomGameStarted(this.room);

  @override
  List<Object?> get props => [room];
}

class RoomLeftSuccess extends RoomState {}

class RoomKickedByHost extends RoomState {}

class RoomCodeCopiedSuccess extends RoomState {
  final String roomCode;

  const RoomCodeCopiedSuccess(this.roomCode);

  @override
  List<Object?> get props => [roomCode];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}
