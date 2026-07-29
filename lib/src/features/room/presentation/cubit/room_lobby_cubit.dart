import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room__lobby_state.dart';

class RoomLobbyCubit extends Cubit<RoomLobbyState> {
  RoomLobbyCubit() : super(RoomInitial());
}
