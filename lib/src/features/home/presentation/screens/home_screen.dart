import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/home/presentation/widgets/home_card.dart';
import 'package:autobus_complete/src/features/home/presentation/widgets/join_room_bottom_sheet.dart';
import 'package:autobus_complete/src/features/home/presentation/widgets/settings_icon_button.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreenBody();
  }
}