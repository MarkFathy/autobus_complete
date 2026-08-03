import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/core/widgets/text_fields/default_text_field.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_cubit.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitComplaintBottomSheet extends StatefulWidget {
  final ComplaintsCubit cubit;

  const SubmitComplaintBottomSheet({required this.cubit, super.key});

  static Future<void> show(BuildContext context, {required ComplaintsCubit cubit}) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SubmitComplaintBottomSheet(cubit: cubit),
  );

  @override
  State<SubmitComplaintBottomSheet> createState() => _SubmitComplaintBottomSheetState();
}

class _SubmitComplaintBottomSheetState extends State<SubmitComplaintBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedType = 'complaint'; // 'complaint' or 'suggestion'

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      unawaited(
        widget.cubit.submit(
          type: _selectedType,
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: widget.cubit,
    child: BlocListener<ComplaintsCubit, ComplaintsState>(
      listener: (context, state) {
        if (state is ComplaintSubmitSuccess) {
          CustomSnackBar.showSuccess(context, message: S.of(context).complaintSentSuccess);
          Navigator.pop(context);
        } else if (state is ComplaintsError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 16.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: context.colors.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.szH,

                // Title
                Text(
                  S.of(context).submitComplaintOrSuggestion,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                16.szH,

                // ── Type Selector Row ───────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = 'complaint'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedType == 'complaint'
                                ? Colors.orange.withValues(alpha: 0.2)
                                : context.colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _selectedType == 'complaint' ? Colors.orange : Colors.transparent,
                              width: 1.5.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.report_problem_outlined,
                                size: 18.sp,
                                color: _selectedType == 'complaint'
                                    ? Colors.orange.shade800
                                    : context.colors.onSurfaceVariant,
                              ),
                              8.szW,
                              Text(
                                S.of(context).complaint,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: _selectedType == 'complaint'
                                      ? Colors.orange.shade800
                                      : context.colors.onSurfaceVariant,
                                  fontWeight: _selectedType == 'complaint' ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    12.szW,
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = 'suggestion'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedType == 'suggestion'
                                ? context.colors.primary.withValues(alpha: 0.2)
                                : context.colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _selectedType == 'suggestion' ? context.colors.primary : Colors.transparent,
                              width: 1.5.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 18.sp,
                                color: _selectedType == 'suggestion'
                                    ? context.colors.primary
                                    : context.colors.onSurfaceVariant,
                              ),
                              8.szW,
                              Text(
                                S.of(context).suggestion,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: _selectedType == 'suggestion'
                                      ? context.colors.primary
                                      : context.colors.onSurfaceVariant,
                                  fontWeight: _selectedType == 'suggestion' ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                16.szH,

                // Subject Title Text Field
                DefaultTextField(
                  controller: _titleController,
                  label: S.of(context).subject,
                  hint: S.of(context).subjectHint,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return S.of(context).pleaseFillAllFields;
                    }
                    return null;
                  },
                ),
                14.szH,

                // Details Text Field (Multiline)
                DefaultTextField(
                  controller: _messageController,
                  label: S.of(context).messageDetails,
                  hint: S.of(context).messageHint,
                  inputType: TextInputType.multiline,
                  maxLines: 5,
                  action: TextInputAction.done,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return S.of(context).pleaseFillAllFields;
                    }
                    return null;
                  },
                ),
                20.szH,

                // Submit Button
                BlocBuilder<ComplaintsCubit, ComplaintsState>(
                  builder: (context, state) => CustomButton(
                    text: S.of(context).send,
                    isLoading: state is ComplaintSubmitting,
                    onPressed: _submit,
                  ),
                ),
                12.szH,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
