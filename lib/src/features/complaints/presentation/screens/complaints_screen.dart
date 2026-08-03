import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_loading_overlay.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_cubit.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_state.dart';
import 'package:autobus_complete/src/features/complaints/presentation/widgets/complaint_item_card.dart';
import 'package:autobus_complete/src/features/complaints/presentation/widgets/submit_complaint_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/complaints_screen_body.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => sl<ComplaintsCubit>()..listenToComplaints(), child: const ComplaintsScreenBody());
}
