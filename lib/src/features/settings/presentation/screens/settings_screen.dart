import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/app_cubit/app_cubit.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/notification_service.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:autobus_complete/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:autobus_complete/src/features/profile/presentation/cubit/profile_state.dart';
import 'package:autobus_complete/src/features/settings/presentation/widgets/language_bottom_sheet.dart';
import 'package:autobus_complete/src/features/settings/presentation/widgets/logout_confirmation_bottom_sheet.dart';
import 'package:autobus_complete/src/features/settings/presentation/widgets/settings_tile_item.dart';
import 'package:autobus_complete/src/features/settings/presentation/widgets/settings_user_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsScreenBody();
}
