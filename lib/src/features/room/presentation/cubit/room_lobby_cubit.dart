import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'room__lobby_state.dart';

class RoomLobbyCubit extends Cubit<RoomLobbyState> {
  RoomLobbyCubit() : super(RoomInitial());
}
