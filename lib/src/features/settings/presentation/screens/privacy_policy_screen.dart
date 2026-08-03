import 'dart:async';

import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/features/settings/presentation/cubit/app_info_cubit.dart';
import 'package:autobus_complete/src/features/settings/presentation/cubit/app_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/privacy_policy_screen_body.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => const PrivacyPolicyScreenBody();
}
