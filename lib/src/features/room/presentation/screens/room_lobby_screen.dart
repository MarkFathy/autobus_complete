import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/room/data/models/room_model.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/leave_room_bottom_sheet.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/player_actions_bottom_sheet.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/room_players_card.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/room_settings_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/room_lobby_screen_body.dart';

class RoomLobbyScreen extends StatelessWidget {
  const RoomLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) => const RoomLobbyScreenBody();
}
