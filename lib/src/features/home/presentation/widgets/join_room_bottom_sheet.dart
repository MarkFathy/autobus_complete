import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _roomCode => _controllers.map((c) => c.text).join();
  bool get _isCodeComplete => _roomCode.length == 6;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Distributes a 6-digit code string across all fields.
  void _fillFromPaste(String digits) {
    final cleaned = digits.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 6) return;

    for (var i = 0; i < 6; i++) {
      _controllers[i].text = cleaned[i];
    }
    setState(() {});
    _focusNodes[5].requestFocus();
  }

  void _onFieldChanged(String value, int index) {
    setState(() {});
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
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
        60.szH,

        // ── 6-Digit PIN Fields ────────────────────────────────────────
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) => SizedBox(
                width: 46.w,
                height: 58.h,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22.sp,
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colors.surfaceContainerHighest,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: context.colors.primary, width: 2.w),
                    ),
                  ),
                  // Intercept the native "Paste" button to fill all 6 fields
                  contextMenuBuilder: (ctx, editableTextState) => AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: [
                      ContextMenuButtonItem(
                        label: 'Paste',
                        onPressed: () async {
                          ContextMenuController.removeAny();
                          final data = await Clipboard.getData(Clipboard.kTextPlain);
                          _fillFromPaste(data?.text ?? '');
                        },
                      ),
                    ],
                  ),
                  onChanged: (value) => _onFieldChanged(value, index),
                ),
              ),
            ),
          ),
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
