import 'dart:async';
import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultTextField extends StatefulWidget {
  final String? hint;
  final bool secure;
  final TextInputType inputType;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final String? label;
  final TextStyle? labelStyle;
  final bool? isOptional;
  final bool? isPhone;
  final void Function(String?)? onSubmitted;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool filled;
  final int? maxLength;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final GestureTapCallback? onTap;
  final String? suffixText;
  final TextInputAction action;
  final bool autoFocus;
  final FocusNode? focusNode;
  final Widget? prefixWidget;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool? isPassword;
  final int? maxLines;
  final bool? hasBorderColor;
  final Color? borderColor;
  final void Function(String?)? onChanged;
  final bool closeWhenTapOutSide;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final AutovalidateMode? autoValidateMode;
  final ValueNotifier<bool?>? validityNotifier;
  final BoxConstraints? prefixIconConstraints;
  final bool enableShake;

  const DefaultTextField({
    super.key,
    this.hint,
    this.secure = false,
    this.inputType = TextInputType.text,
    this.borderColor,
    this.onTap,
    this.controller,
    this.contentPadding,
    this.closeWhenTapOutSide = true,
    this.hasBorderColor = false,
    this.validator,
    this.label,
    this.labelStyle,
    this.isOptional = false,
    this.isPhone = false,
    this.onSubmitted,
    this.isPassword = false,
    this.fillColor,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixWidget,
    this.maxLength,
    this.filled = true,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.action = TextInputAction.next,
    this.focusNode,
    this.autoFocus = false,
    this.suffixText,
    this.suffixIcon,
    this.maxLines,
    this.onChanged,
    this.style,
    this.padding,
    this.borderRadius,
    this.autoValidateMode,
    this.hintStyle,
    this.validityNotifier,
    this.prefixIconConstraints,
    this.enableShake = true,
  });

  @override
  State<DefaultTextField> createState() => DefaultTextFieldState();
}

class DefaultTextFieldState extends State<DefaultTextField> with SingleTickerProviderStateMixin {
  late bool _isSecure;
  late final AnimationController _shakeController;
  late FocusNode _focusNode;
  bool _isSelfCreatedFocusNode = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _isSecure = widget.isPassword ?? false;
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isSelfCreatedFocusNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DefaultTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      if (_isSelfCreatedFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _isSelfCreatedFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _isSelfCreatedFocusNode = true;
      }
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_isSelfCreatedFocusNode) {
      _focusNode.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      if (_autoValidateMode != AutovalidateMode.always) {
        setState(() {
          _autoValidateMode = AutovalidateMode.always;
        });
      }
    }
  }

  void shake() {
    if (widget.enableShake && mounted) {
      unawaited(_shakeController.forward(from: 0));
    }
  }

  void _validateInput(String value) {
    if (widget.validityNotifier == null) return;

    if (value.isEmpty) {
      widget.validityNotifier!.value = false;
      return;
    }

    final valid = Validators.validatePhone(widget.controller?.text ?? '') == null;

    widget.validityNotifier!.value = valid;
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(AppCircular.r16);

    Widget fieldWidget = Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: AppSize.sH8),
          ],

          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            autovalidateMode: widget.autoValidateMode ?? _autoValidateMode,
            validator: widget.validator,
            onChanged: widget.onChanged ?? _validateInput,
            onTap: widget.onTap,
            obscureText: widget.isPassword ?? false ? _isSecure : widget.secure,
            keyboardType: widget.isPhone ?? false ? TextInputType.phone : widget.inputType,
            maxLength: widget.maxLength,
            maxLines: widget.inputType == TextInputType.multiline ? widget.maxLines ?? 7 : 1,
            readOnly: widget.readOnly,
            textAlign: widget.textAlign!,
            style:
                widget.style ?? context.textTheme.bodyLarge?.copyWith(color: context.colors.primary, fontSize: 16.sp),
            cursorColor: context.colors.primary,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  widget.contentPadding ??
                  EdgeInsetsDirectional.only(top: AppPadding.pH20, bottom: AppPadding.pH20, start: AppPadding.pH12),
              counterText: '',
              filled: widget.filled,
              fillColor: widget.fillColor ?? context.colors.surfaceContainerHighest,
              hintText: widget.hint,
              hintStyle:
                  widget.hintStyle ??
                  context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
              errorStyle: context.textTheme.bodySmall?.copyWith(
                color: context.colors.error,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),

              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: widget.prefixIconConstraints,
              prefix: widget.prefixWidget,

              suffixText: widget.suffixText,
              suffixIcon: widget.isPassword ?? false
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _isSecure = !_isSecure;
                        });
                      },
                      icon: Icon(
                        _isSecure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: context.colors.onSurfaceVariant,
                      ),
                    )
                  : widget.isPhone ?? false
                  ? _suffixIconWhenPhoneType(context)
                  : widget.suffixIcon,

              enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),

              focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),

              errorBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: BorderSide(color: context.colors.error),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: BorderSide(color: context.colors.error),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.enableShake) {
      fieldWidget = fieldWidget
          .animate(controller: _shakeController, autoPlay: false)
          .shake(duration: 400.ms, hz: 4, offset: const Offset(8, 0));
    }

    return fieldWidget;
  }
}

/// Phone suffix
Widget _suffixIconWhenPhoneType(BuildContext context) => SizedBox(
  width: AppSize.sW90,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '+966',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colors.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(width: AppSize.sW8),
    ],
  ),
);
