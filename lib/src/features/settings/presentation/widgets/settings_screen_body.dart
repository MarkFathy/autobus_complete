part of '../screens/settings_screen.dart';

class SettingsScreenBody extends StatefulWidget {
  const SettingsScreenBody({super.key});

  @override
  State<SettingsScreenBody> createState() => _SettingsScreenBodyState();
}

class _SettingsScreenBodyState extends State<SettingsScreenBody> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).logoutSuccess,
            );
            Go.offAllNamed(NamedRoutes.login);
          } else if (state is AuthError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final authCubit = context.read<AuthCubit>();

          return AppLoadingOverlay(
            isLoading: isLoading,
            child: AppScaffold(
              safeTop: true,
              safeBottom: true,
              appBar: CustomAppBar(
                showBackButton: true,
                title: Text(
                  S.of(context).settings,
                  style: getTextStyle().s20.w700.whiteColor,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    20.szH,
                    // ── User Header Row ──────────────────────────────
                    SettingsUserHeader(
                      onTap: () => Go.toNamed(
                        NamedRoutes.profile,
                        transition: TransitionType.slide,
                      ),
                    ),
                    20.szH,

                    // ── Settings List Group ──────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.yellowColor.withValues(alpha: 0.3),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Language Tile
                          SettingsTileItem(
                            icon: Icons.language_rounded,
                            title: S.of(context).language,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isArabic
                                      ? S.of(context).arabic
                                      : S.of(context).english,
                                  style: getTextStyle().s14.w400.yellowColor,
                                ),
                                8.szW,
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16.sp,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                            onTap: () {
                              LanguageBottomSheet.show(
                                context,
                                onLanguageSelected: (langCode) {
                                  context
                                      .read<AppCubit>()
                                      .changeLanguage(langCode);
                                },
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 16.w,
                            endIndent: 16.w,
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                          ),

                          // Notifications Tile
                          SettingsTileItem(
                            icon: Icons.notifications_outlined,
                            title: S.of(context).notifications,
                            trailing: Switch(
                              value: _isNotificationEnabled,
                              activeThumbColor: AppColors.yellowColor,
                              activeTrackColor:
                                  AppColors.yellowColor.withValues(alpha: 0.3),
                              inactiveThumbColor: AppColors.greyColor,
                              inactiveTrackColor:
                                  AppColors.scaffoldBackgroundColor,
                              onChanged: (value) {
                                setState(() {
                                  _isNotificationEnabled = value;
                                });
                              },
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 16.w,
                            endIndent: 16.w,
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                          ),

                          // About Us Tile
                          SettingsTileItem(
                            icon: Icons.info_outline_rounded,
                            title: S.of(context).aboutUs,
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            onTap: () {
                              // About Us action
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 16.w,
                            endIndent: 16.w,
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                          ),

                          // Contact Us Tile
                          SettingsTileItem(
                            icon: Icons.headset_mic_outlined,
                            title: S.of(context).contactUs,
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            onTap: () {
                              // Contact Us action
                            },
                          ),
                        ],
                      ),
                    ),
                    20.szH,

                    // ── Logout Button ────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.redColor.withValues(alpha: 0.4),
                          width: 1.w,
                        ),
                      ),
                      child: SettingsTileItem(
                        icon: Icons.logout_rounded,
                        title: S.of(context).logout,
                        iconColor: AppColors.redColor,
                        textColor: AppColors.redColor,
                        onTap: () {
                          LogoutConfirmationBottomSheet.show(
                            context,
                            onConfirmLogout: () {
                              authCubit.logout();
                            },
                          );
                        },
                      ),
                    ),
                    30.szH,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
