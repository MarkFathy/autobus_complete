import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/helpers/validators.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/core/widgets/text_fields/default_text_field.dart';
import 'package:autobus_complete/src/core/widgets/user_avatar_picker.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../widgets/register_screen_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => const RegisterScreenBody();
}
