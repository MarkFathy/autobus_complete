part of '../screens/complaints_screen.dart';

class ComplaintsScreenBody extends StatelessWidget {
  const ComplaintsScreenBody({super.key});

  void _openSubmitBottomSheet(BuildContext context) {
    final cubit = context.read<ComplaintsCubit>();
    unawaited(SubmitComplaintBottomSheet.show(context, cubit: cubit));
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      contentPadding: EdgeInsets.all(20.r),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(Icons.delete_forever_rounded, color: Colors.red.shade700, size: 32.sp),
          ),
          16.szH,
          Text(
            S.of(ctx).deleteComplaint,
            style: ctx.textTheme.titleMedium?.copyWith(
              color: ctx.colors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
          ),
          8.szH,
          Text(
            S.of(ctx).deleteComplaintConfirmation,
            style: ctx.textTheme.bodyMedium?.copyWith(color: ctx.colors.onSurfaceVariant, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
          20.szH,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(color: ctx.colors.outline.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    S.of(ctx).cancel,
                    style: ctx.textTheme.bodyMedium?.copyWith(color: ctx.colors.onSurface, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              12.szW,
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: ctx.colors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    S.of(ctx).yesDelete,
                    style: ctx.textTheme.bodyMedium?.copyWith(color: ctx.colors.onError, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<ComplaintsCubit, ComplaintsState>(
    builder: (context, state) {
      final isLoading = state is ComplaintsLoading;

      return AppLoadingOverlay(
        isLoading: isLoading,
        child: AppScaffold(
          safeTop: true,
          appBar: CustomAppBar(
            title: Text(
              S.of(context).complaintsAndSuggestions,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              // ── Header Call-to-Action Banner ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  child: Container(
                    padding: EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colors.primary.withValues(alpha: 0.15),
                          context.colors.surfaceContainerHighest,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.support_agent_rounded, color: context.colors.primary, size: 24.sp),
                            ),
                            12.szW,
                            Expanded(
                              child: Text(
                                S.of(context).complaintsAndSuggestions,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colors.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        12.szH,
                        CustomButton(
                          text: S.of(context).submitComplaintOrSuggestion,
                          onPressed: () => _openSubmitBottomSheet(context),
                          height: 48.h,
                          borderRadius: BorderRadius.circular(12.r),
                          textStyle: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0),
                ),
              ),

              // ── Complaints List or Empty State ───────────────────────────
              if (state is ComplaintsLoaded) ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final complaint = state.complaints[index];
                    final isDeletable = !complaint.isReplied;

                    final cardWidget = ComplaintItemCard(complaint: complaint);

                    if (!isDeletable) {
                      return cardWidget.animate().fadeIn(duration: (200 + index * 50).ms).slideY(begin: 0.1, end: 0);
                    }

                    return Dismissible(
                      key: Key(complaint.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async => _showDeleteConfirmationDialog(context),
                      onDismissed: (direction) {
                        unawaited(context.read<ComplaintsCubit>().deleteComplaint(complaint.id));
                        CustomSnackBar.showSuccess(context, message: S.of(context).complaintDeletedSuccess);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        margin: EdgeInsets.only(bottom: 14.h),
                        decoration: BoxDecoration(
                          color: context.colors.error,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              S.of(context).deleteComplaint,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colors.onError,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                            8.szW,
                            Icon(Icons.delete_outline_rounded, color: context.colors.onError, size: 24.sp),
                          ],
                        ),
                      ),
                      child: cardWidget,
                    ).animate().fadeIn(duration: (200 + index * 50).ms).slideY(begin: 0.1, end: 0);
                  }, childCount: state.complaints.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              ] else if (state is ComplaintsEmpty) ...[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64.sp,
                          color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        16.szH,
                        Text(
                          S.of(context).noComplaintsYet,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                  ),
                ),
              ] else if (state is ComplaintsError) ...[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      state.message,
                      style: context.textTheme.bodyMedium?.copyWith(color: context.colors.error),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
