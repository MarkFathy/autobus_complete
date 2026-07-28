part of '../screens/home_screen.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      appBar: CustomAppBar(
        showBackButton: false,
        leading: SettingsIconButton(
          onPressed: () => Go.toNamed(
            NamedRoutes.settings,
            transition: TransitionType.slide,
          ),
        ),
        title: Assets.pngs.logo.image(height: 45.h, width: 45.w),
        action: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: UserProfileAvatar(
            radius: 18.r,
            onTap: () => Go.toNamed(
              NamedRoutes.profile,
              transition: TransitionType.slide,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          60.szH,
          HomeCard(
            icon: Icons.people_outline_outlined,
            title: S.of(context).hostGame,
            subtitle: S.of(context).hostGameSubtitle,
            onTap: () {
              // Host Game action
            },
          ),
          16.szH,
          HomeCard(
            icon: Icons.login_rounded,
            title: S.of(context).joinGame,
            subtitle: S.of(context).joinGameSubtitle,
            onTap: () {
              // Join Game action
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: Assets.lotties.busHome.lottie(width: 350.w, height: 200.h),
          ),
        ],
      ),
    );
  }
}
