import 'dart:async';

import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/helpers/validators.dart';
import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/core/widgets/text_fields/default_text_field.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:autobus_complete/src/features/auth/presentation/widgets/forget_password_button.dart';
import 'package:autobus_complete/src/features/auth/presentation/widgets/forget_password_dialog.dart';
import 'package:autobus_complete/src/features/auth/presentation/widgets/google_login_button.dart';
import 'package:autobus_complete/src/features/auth/presentation/widgets/or_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const LoginScreenBody();
}
