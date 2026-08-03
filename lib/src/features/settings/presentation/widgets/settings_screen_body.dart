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
    // ponytail: silently fetch profile if not cached to avoid blocking UI
    final profileCubit = sl<ProfileCubit>();
    if (profileCubit.currentUser == null) {
      unawaited(profileCubit.getUserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final authCubit = sl<AuthCubit>();
    final profileCubit = sl<ProfileCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: profileCubit),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, authState) {
          if (authState is AuthUnauthenticated) {
            CustomSnackBar.showSuccess(context, message: S.of(context).logoutSuccess);
            unawaited(Go.offAllNamed(NamedRoutes.login));
          } else if (authState is AuthError) {
            CustomSnackBar.showError(context, message: authState.message);
          }
        },
        child: BlocSelector<AuthCubit, AuthState, bool>(
          bloc: authCubit,
          selector: (authState) => authState is AuthLoading,
          builder: (context, isAuthLoading) => AppLoadingOverlay(
            isLoading: isAuthLoading,
            child: AppScaffold(
                safeTop: true,
                appBar: CustomAppBar(
                  title: Text(
                    S.of(context).settings,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ── User Header Row ──────────────────────────────
                      BlocSelector<ProfileCubit, ProfileState, (String, String, String?)>(
                        bloc: profileCubit,
                        selector: (state) {
                          final currentUser = profileCubit.currentUser;
                          final firebaseUser = FirebaseAuth.instance.currentUser;
                          final userName = (currentUser?.name != null && currentUser!.name.trim().isNotEmpty)
                              ? currentUser.name
                              : (firebaseUser?.displayName ?? 'User');
                          final userEmail = (currentUser?.email != null && currentUser!.email.trim().isNotEmpty)
                              ? currentUser.email
                              : (firebaseUser?.email ?? '');
                          final userPhoto = currentUser?.photoUrl ?? firebaseUser?.photoURL;
                          return (userName, userEmail, userPhoto);
                        },
                        builder: (context, userTuple) => SettingsUserHeader(
                          name: userTuple.$1,
                          email: userTuple.$2,
                          imageUrl: userTuple.$3,
                          onTap: () async {
                            await Go.toNamed(NamedRoutes.profile, transition: TransitionType.slide);
                            if (context.mounted) {
                              unawaited(profileCubit.getUserProfile());
                            }
                          },
                        ),
                      ),
                      20.szH,
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
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
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  8.szW,
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16.sp,
                                    color: context.colors.onSurfaceVariant,
                                  ),
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
                              color: context.colors.outline.withValues(alpha: 0.2),
                            ),

                            // Notifications Tile
                            SettingsTileItem(
                              icon: Icons.notifications_outlined,
                              title: S.of(context).notifications,
                              trailing: Switch(
                                value: _isNotificationEnabled,
                                activeThumbColor: context.colors.primary,
                                activeTrackColor: context.colors.primaryContainer,
                                inactiveThumbColor: context.colors.outline,
                                inactiveTrackColor: context.colors.surface,
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
                              color: context.colors.outline.withValues(alpha: 0.2),
                            ),

                            // About Us Tile
                            SettingsTileItem(
                              icon: Icons.info_outline_rounded,
                              title: S.of(context).aboutUs,
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16.sp,
                                color: context.colors.onSurfaceVariant,
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
                              color: context.colors.outline.withValues(alpha: 0.2),
                            ),

                            // Privacy Policy Tile
                            SettingsTileItem(
                              icon: Icons.privacy_tip_outlined,
                              title: S.of(context).privacyPolicy,
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16.sp,
                                color: context.colors.onSurfaceVariant,
                              ),
                              onTap: () {
                                unawaited(Go.toNamed(NamedRoutes.privacyPolicy));
                              },
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.8,
                              indent: 16.w,
                              endIndent: 16.w,
                              color: context.colors.outline.withValues(alpha: 0.2),
                            ),

                            // Complaints & Suggestions Tile
                            SettingsTileItem(
                              icon: Icons.rate_review_outlined,
                              title: S.of(context).complaintsAndSuggestions,
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16.sp,
                                color: context.colors.onSurfaceVariant,
                              ),
                              onTap: () {
                                unawaited(Go.toNamed(NamedRoutes.complaints));
                              },
                            ),
                          ],
                        ),
                      ),
                      20.szH,

                      // ── Logout Button ────────────────────────────────
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: context.colors.secondary.withValues(alpha: 0.4), width: 1.w),
                        ),
                        child: SettingsTileItem(
                          icon: Icons.logout_rounded,
                          title: S.of(context).logout,
                          iconColor: context.colors.secondary,
                          textColor: context.colors.secondary,
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
            ),
          ),
        ),
      );
    }
  }
