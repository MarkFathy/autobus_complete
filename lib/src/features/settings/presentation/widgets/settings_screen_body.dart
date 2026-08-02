part of '../screens/settings_screen.dart';

class SettingsScreenBody extends StatefulWidget {
  const SettingsScreenBody({super.key});

  @override
  State<SettingsScreenBody> createState() => _SettingsScreenBodyState();
}

class _SettingsScreenBodyState extends State<SettingsScreenBody> {
  late bool _isNotificationEnabled;

  @override
  void initState() {
    super.initState();
    _isNotificationEnabled = sl<NotificationService>().isNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) {
          final cubit = sl<ProfileCubit>();
          unawaited(cubit.getUserProfile());
          return cubit;
        }),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is AuthUnauthenticated) {
            CustomSnackBar.showSuccess(context, message: S.of(context).logoutSuccess);
            unawaited(Go.offAllNamed(NamedRoutes.login));
          } else if (authState is AuthError) {
            CustomSnackBar.showError(context, message: authState.message);
          }
        },
        builder: (context, authState) {
          final isAuthLoading = authState is AuthLoading;
          final authCubit = context.read<AuthCubit>();

          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              final isProfileLoading = profileState is ProfileLoading;
              final profileCubit = context.read<ProfileCubit>();
              final currentUser = profileCubit.currentUser;
              final firebaseUser = FirebaseAuth.instance.currentUser;

              final userName = (currentUser?.name != null && currentUser!.name.trim().isNotEmpty)
                  ? currentUser.name
                  : (firebaseUser?.displayName ?? 'User');
              final userEmail = (currentUser?.email != null && currentUser!.email.trim().isNotEmpty)
                  ? currentUser.email
                  : (firebaseUser?.email ?? '');
              final userPhoto = currentUser?.photoUrl ?? firebaseUser?.photoURL;

              return AppLoadingOverlay(
                isLoading: isAuthLoading || isProfileLoading,
                child: AppScaffold(
                  safeTop: true,
                  appBar: CustomAppBar(title: Text(S.of(context).settings, style: getTextStyle().s20.w700.whiteColor)),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        20.szH,
                        // ── User Header Row ──────────────────────────────
                        SettingsUserHeader(
                          name: userName,
                          email: userEmail,
                          imageUrl: userPhoto,
                          onTap: () async {
                            await Go.toNamed(NamedRoutes.profile, transition: TransitionType.slide);
                            if (context.mounted) {
                              unawaited(context.read<ProfileCubit>().getUserProfile());
                            }
                          },
                        ),
                        20.szH,

                        // ── Settings List Group ──────────────────────────
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldFillColor,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.yellowColor.withValues(alpha: 0.3), width: 1.w),
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
                                      isArabic ? S.of(context).arabic : S.of(context).english,
                                      style: getTextStyle().s14.w400.yellowColor,
                                    ),
                                    8.szW,
                                    Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: AppColors.greyColor),
                                  ],
                                ),
                                onTap: () {
                                  unawaited(
                                    LanguageBottomSheet.show(
                                      context,
                                      onLanguageSelected: (langCode) {
                                        unawaited(context.read<AppCubit>().changeLanguage(langCode));
                                      },
                                    ),
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
                                  activeTrackColor: AppColors.yellowColor.withValues(alpha: 0.3),
                                  inactiveThumbColor: AppColors.greyColor,
                                  inactiveTrackColor: AppColors.scaffoldBackgroundColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _isNotificationEnabled = value;
                                    });
                                    unawaited(sl<NotificationService>().setNotificationsEnabled(enable: value));
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
                                  unawaited(Go.toNamed(NamedRoutes.aboutGame));
                                },
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.8,
                                indent: 16.w,
                                endIndent: 16.w,
                                color: AppColors.greyColor.withValues(alpha: 0.2),
                              ),

                              // Privacy Policy Tile
                              SettingsTileItem(
                                icon: Icons.privacy_tip_outlined,
                                title: S.of(context).privacyPolicy,
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16.sp,
                                  color: AppColors.greyColor,
                                ),
                                onTap: () {
                                  unawaited(Go.toNamed(NamedRoutes.privacyPolicy));
                                },
                              ),
                            ],
                          ),
                        ),
                        20.szH,

                        // ── Logout Button ────────────────────────────────
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldFillColor,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.redColor.withValues(alpha: 0.4), width: 1.w),
                          ),
                          child: SettingsTileItem(
                            icon: Icons.logout_rounded,
                            title: S.of(context).logout,
                            iconColor: AppColors.redColor,
                            textColor: AppColors.redColor,
                            onTap: () {
                              unawaited(LogoutConfirmationBottomSheet.show(context, onConfirmLogout: authCubit.logout));
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
          );
        },
      ),
    );
  }
}
