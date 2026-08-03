import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ComplaintItemCard extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintItemCard({required this.complaint, super.key});

  @override
  Widget build(BuildContext context) {
    final isSuggestion = complaint.type.toLowerCase() == 'suggestion' || complaint.type == 'مقترح';
    final typeBgColor = isSuggestion
        ? context.colors.primary.withValues(alpha: 0.15)
        : Colors.orange.withValues(alpha: 0.15);
    final typeTextColor = isSuggestion ? context.colors.primary : Colors.orange.shade700;
    final typeLabel = isSuggestion ? S.of(context).suggestion : S.of(context).complaint;

    final isReplied = complaint.isReplied;
    final statusBgColor = isReplied ? Colors.green.withValues(alpha: 0.15) : Colors.amber.withValues(alpha: 0.15);
    final statusTextColor = isReplied ? Colors.green.shade700 : Colors.amber.shade900;
    final statusLabel = isReplied ? S.of(context).replied : S.of(context).pendingResponse;
    final statusIcon = isReplied ? Icons.check_circle_rounded : Icons.access_time_rounded;

    final formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(complaint.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isReplied ? Colors.green.withValues(alpha: 0.3) : context.colors.primary.withValues(alpha: 0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10.r, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Badges Row ──────────────────────────────────────────
          Row(
            children: [
              // Type Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: typeBgColor, borderRadius: BorderRadius.circular(8.r)),
                child: Text(
                  typeLabel,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: typeTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              8.szW,
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8.r)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 13.sp, color: statusTextColor),
                    4.szW,
                    Text(
                      statusLabel,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: statusTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Date
              Text(
                formattedDate,
                style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant, fontSize: 11.sp),
              ),
            ],
          ),
          12.szH,

          // ── Subject Title (if present) ──────────────────────────────
          if (complaint.title.trim().isNotEmpty) ...[
            Text(
              complaint.title,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            6.szH,
          ],

          // ── Message Content ──────────────────────────────────────────
          Text(
            complaint.message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurface,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),

          // ── Admin Response Section ──────────────────────────────────
          if (isReplied && complaint.adminReply != null && complaint.adminReply!.trim().isNotEmpty) ...[
            14.szH,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(color: context.colors.primary, shape: BoxShape.circle),
                        child: Icon(Icons.admin_panel_settings_rounded, size: 14.sp, color: context.colors.onPrimary),
                      ),
                      8.szW,
                      Text(
                        S.of(context).adminReply,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  8.szH,
                  Text(
                    complaint.adminReply!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.onSurface,
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          ],
        ],
      ),
    );
  }
}
