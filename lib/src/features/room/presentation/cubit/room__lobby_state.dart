part of 'room_lobby_cubit.dart';

sealed class RoomLobbyState extends Equatable {
  const RoomLobbyState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomLobbyState {}
