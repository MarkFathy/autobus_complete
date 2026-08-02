part of '../screens/home_screen.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: sl<RoomCubit>(),
    child: BlocConsumer<RoomCubit, RoomState>(
      listener: (context, state) {
        if (state is RoomCreatedSuccess || state is RoomJoinedSuccess) {
          unawaited(Go.toNamed(NamedRoutes.roomLobby));
        } else if (state is RoomError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is RoomLoading;
        final roomCubit = context.read<RoomCubit>();

        return AppLoadingOverlay(
          isLoading: isLoading,
          child: AppScaffold(
            appBar: CustomAppBar(
              showBackButton: false,
              leading: SettingsIconButton(
                onPressed: () => unawaited(Go.toNamed(NamedRoutes.settings, transition: TransitionType.slide)),
              ),
              action: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Assets.pngs.logo.image(height: 45.h, width: 45.w),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  60.szH,
                  HomeCard(
                    icon: Icons.people_outline_outlined,
                    title: S.of(context).hostGame,
                    subtitle: S.of(context).hostGameSubtitle,
                    onTap: roomCubit.createRoom,
                  ),
                  16.szH,
                  HomeCard(
                    icon: Icons.login_rounded,
                    title: S.of(context).joinGame,
                    subtitle: S.of(context).joinGameSubtitle,
                    onTap: () {
                      unawaited(JoinRoomBottomSheet.show(context, onJoinPressed: roomCubit.joinRoom));
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.h),
                    child: Assets.lotties.busHome.lottie(width: 350.w, height: 200.h),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
