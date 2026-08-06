import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/core/services/app_lock_service.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    final appLockService = sl<AppLockService>();
    await appLockService.fetchAndActivate();

    if (mounted) {
      setState(() => _isRefreshing = false);
      if (appLockService.isLocked) {
        CustomSnackBar.showWarning(
          context,
          message: S.of(context).appLockedMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLockService = sl<AppLockService>();
    final customTitle = appLockService.lockTitle;
    final customMessage = appLockService.lockMessage;

    final displayTitle = customTitle.trim().isNotEmpty ? customTitle : S.of(context).appLockedTitle;
    final displayMessage = customMessage.trim().isNotEmpty ? customMessage : S.of(context).appLockedMessage;

    return PopScope(
      canPop: false,
      child: AppScaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.pngs.logo.image(height: 120.h, width: 120.w),
                    SizedBox(height: 32.h),

                    Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.yellowColor.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: AppColors.yellowColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_clock_rounded,
                              size: 56.r,
                              color: AppColors.yellowColor,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Text(
                            displayTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 12.h),

                          Text(
                            displayMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.greyColor,
                                  height: 1.5,
                                ),
                          ),
                          SizedBox(height: 28.h),

                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _isRefreshing ? null : _handleRefresh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowColor,
                                foregroundColor: AppColors.blackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                elevation: 0,
                              ),
                              child: _isRefreshing
                                  ? SizedBox(
                                      height: 24.r,
                                      width: 24.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.blackColor),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.refresh_rounded, size: 20.r),
                                        SizedBox(width: 8.w),
                                        Text(
                                          S.of(context).retry,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
