import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/text_fields/custom_pin_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinRoomBottomSheet extends StatefulWidget {
  final ValueChanged<String> onJoinPressed;

  const JoinRoomBottomSheet({required this.onJoinPressed, super.key});

  static Future<void> show(BuildContext context, {required ValueChanged<String> onJoinPressed}) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
    builder: (modalContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
      child: JoinRoomBottomSheet(onJoinPressed: onJoinPressed),
    ),
  );

  @override
  State<JoinRoomBottomSheet> createState() => _JoinRoomBottomSheetState();
}

class _JoinRoomBottomSheetState extends State<JoinRoomBottomSheet> {
  // ponytail: use single controller & pinput instead of 6 controllers and 6 focus nodes
  final TextEditingController _pinController = TextEditingController();

  String get _roomCode => _pinController.text;
  bool get _isCodeComplete => _roomCode.length == 6;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 380.h,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Drag Handle ─────────────────────────────────────────────
        Container(
          width: 45.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: context.colors.outline.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        24.szH,

        // ── Title & Subtitle ─────────────────────────────────────────
        Text(
          S.of(context).joinGame,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 22.sp,
          ),
        ),
        8.szH,
        Text(
          S.of(context).enterRoomCode,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
        40.szH,

        // ── 6-Digit PIN Field ────────────────────────────────────────
        CustomPinInput(
          controller: _pinController,
          onChanged: (_) => setState(() {}),
          onCompleted: (code) {
            setState(() {});
          },
        ),
        const Spacer(),

        // ── Join Button ──────────────────────────────────────────────
        CustomButton(
          text: S.of(context).join,
          onPressed: _isCodeComplete
              ? () {
                  Go.back();
                  widget.onJoinPressed(_roomCode);
                }
              : null,
        ),
        16.szH,
      ],
    ),
  );
}
