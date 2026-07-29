import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinRoomBottomSheet extends StatefulWidget {
  final ValueChanged<String> onJoinPressed;

  const JoinRoomBottomSheet({
    super.key,
    required this.onJoinPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onJoinPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: JoinRoomBottomSheet(onJoinPressed: onJoinPressed),
      ),
    );
  }

  @override
  State<JoinRoomBottomSheet> createState() => _JoinRoomBottomSheetState();
}

class _JoinRoomBottomSheetState extends State<JoinRoomBottomSheet> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _roomCode => _controllers.map((c) => c.text).join();
  bool get _isCodeComplete => _roomCode.length == 6;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380.h, // Increased comfortable height for the bottom sheet
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Drag Handle Pill
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          24.szH,

          //Title & Subtitle
          Text(
            S.of(context).joinGame,
            style: getTextStyle().s22.w700.whiteColor,
          ),
          8.szH,
          Text(
            S.of(context).enterRoomCode,
            style: getTextStyle().s14.w400.greyColor,
          ),
          60.szH,

          //6 Digit PIN Fields
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 46.w,
                  height: 58.h,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: getTextStyle().s22.w700.yellowColor,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.textFieldFillColor,
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.yellowColor.withValues(alpha: 0.3),
                          width: 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.yellowColor,
                          width: 2.w,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
Spacer(),
          //Join Button
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
}
