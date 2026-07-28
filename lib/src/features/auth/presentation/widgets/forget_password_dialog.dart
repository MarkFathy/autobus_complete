import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/helpers/validators%20copy.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/core/widgets/text_fields/default_text_field.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autobus_complete/src/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordDialog extends StatefulWidget {
  final AuthCubit authCubit;

  const ForgetPasswordDialog({super.key, required this.authCubit});

  static void show(BuildContext context, {required AuthCubit authCubit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => ForgetPasswordDialog(authCubit: authCubit),
    );
  }

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailKey = GlobalKey<DefaultTextFieldState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return BlocProvider.value(
      value: widget.authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSent) {
            Navigator.of(context).pop();
            CustomSnackBar.showSuccess(context, message: state.message);
          } else if (state is AuthError) {
            _emailKey.currentState?.shake();
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: bottomInset + safeAreaBottom + 30.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  16.szH,
                  Text(
                    S.of(context).forgotPasswordTitle,
                    style: getTextStyle().whiteColor.s20.bold,
                  ),
                  8.szH,
                  Text(
                    S.of(context).enterEmailToResetPassword,
                    style: getTextStyle().greyColor.s14.w400,
                  ),
                  20.szH,
                  DefaultTextField(
                    key: _emailKey,
                    controller: _emailController,
                    hint: S.of(context).email,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) => Validators.validateEmail(
                      value,
                      emptyMessage: S.of(context).emailRequired,
                      invalidMessage: S.of(context).invalidEmail,
                    ),
                  ),
                  24.szH,
                  CustomButton(
                    text: S.of(context).sendResetLink,
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) {
                              _emailKey.currentState?.shake();
                              return;
                            }
                            final email = _emailController.text.trim();
                            widget.authCubit.sendPasswordResetEmail(email);
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
