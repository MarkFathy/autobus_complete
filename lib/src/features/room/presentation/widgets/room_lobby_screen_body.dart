part of '../screens/room_lobby_screen.dart';

class RoomLobbyScreenBody extends StatelessWidget {
  const RoomLobbyScreenBody({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
      value: sl<RoomCubit>(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          if (state is RoomCodeCopiedSuccess) {
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).roomCodeCopied,
            );
          } else if (state is RoomGameStarted) {
            unawaited(Go.offNamed(NamedRoutes.countdown));
          } else if (state is RoomLeftSuccess) {
            unawaited(Go.offAllNamed(NamedRoutes.home));
          } else if (state is RoomKickedByHost) {
            CustomSnackBar.showError(
              context,
              message: S.of(context).kickedByHost,
            );
            unawaited(Go.offAllNamed(NamedRoutes.home));
          } else if (state is RoomError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final roomCubit = context.read<RoomCubit>();
          final room = roomCubit.currentRoom;
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;

          if (room == null) {
            return AppScaffold(
              appBar: CustomAppBar(
                title: Text(
                  S.of(context).lobby,
                  style: getTextStyle().s20.w700.whiteColor,
                ),
              ),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.yellowColor),
              ),
            );
          }

          final isHost = room.hostId == currentUserId;
          final playersList = room.players.map((p) => RoomPlayer(
              id: p.id,
              name: p.name,
              photoUrl: p.photoUrl,
              isHost: p.isHost,
              isReady: p.isReady,
            )).toList();

          final selectedCategoryIds =
              room.categories.map((c) => c.id).toSet();

          final nonHostPlayers = room.players.where((p) => !p.isHost).toList();
          final allOtherPlayersReady = nonHostPlayers.isNotEmpty &&
              nonHostPlayers.every((p) => p.isReady);
          final hasEnoughCategories = room.categories.length >= 4;
          final canStartGame =
              isHost && allOtherPlayersReady && hasEnoughCategories;

          final currentPlayer = room.players.firstWhere(
            (p) => p.id == currentUserId,
            orElse: () => RoomPlayerModel(
              id: currentUserId ?? '',
              name: 'Player',
            ),
          );

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              unawaited(
                LeaveRoomBottomSheet.show(
                  context,
                  onLeaveConfirmed: roomCubit.leaveRoom,
                ),
              );
            },
            child: AppScaffold(
              appBar: CustomAppBar(
                onTap: () {
                  unawaited(
                    LeaveRoomBottomSheet.show(
                      context,
                      onLeaveConfirmed: roomCubit.leaveRoom,
                    ),
                  );
                },
                title: Text(
                  S.of(context).lobby,
                  style: getTextStyle().s20.w700.whiteColor,
                ),
              ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.textFieldFillColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                border: Border.all(
                  color: AppColors.yellowColor.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isHost && !canStartGame) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.yellowColor,
                          size: 16.sp,
                        ),
                        6.szW,
                        Flexible(
                          child: Text(
                            !allOtherPlayersReady
                                ? S.of(context).waitingForOtherPlayers
                                : S.of(context).selectAtLeast4Categories,
                            style: getTextStyle().s12.w500.yellowColor,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    10.szH,
                  ],

                  if (isHost)
                    CustomButton(
                      text: S.of(context).startGame,
                      onPressed: canStartGame
                          ? roomCubit.startGame
                          : null,
                    )
                  else
                    CustomButton(
                      text: currentPlayer.isReady
                          ? S.of(context).unReady
                          : S.of(context).ready,
                      backgroundColor: currentPlayer.isReady
                          ? AppColors.greyColor
                          : AppColors.cyanColor,
                      onPressed: roomCubit.toggleReadyStatus,
                    ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  16.szH,
                  // ── Room Code Card ─────────────────────────────────────
                  RoomCodeCard(
                    title: S.of(context).roomCode,
                    roomCode: room.roomCode,
                    onTap: () {
                      unawaited(roomCubit.copyRoomCodeToClipboard(room.roomCode));
                    },
                  ),
                  20.szH,

                  // ── Room Settings Card (Host Only) ──────────────────────
                  if (isHost) ...[
                    RoomSettingsCard(
                      initialRounds: room.rounds,
                      initialCategories: selectedCategoryIds,
                      availableCategories: roomCubit.availableCategories.isNotEmpty
                          ? roomCubit.availableCategories
                          : room.categories,
                      onRoundsChanged: (rounds) {
                        if (isHost) {
                          unawaited(
                            roomCubit.updateRoomSettings(
                              rounds: rounds,
                              categories: room.categories,
                            ),
                          );
                        }
                      },
                      onCategoriesChanged: (updatedCategoryIds) {
                        if (isHost) {
                          final availableCategories =
                              roomCubit.availableCategories.isNotEmpty
                                  ? roomCubit.availableCategories
                                  : room.categories;

                          final selectedEntities = availableCategories
                              .where((c) => updatedCategoryIds.contains(c.id))
                              .toList();

                          unawaited(
                            roomCubit.updateRoomSettings(
                              rounds: room.rounds,
                              categories: selectedEntities,
                            ),
                          );
                        }
                      },
                    ),
                    20.szH,
                  ],

                  // ── Room Joined Players Card ────────────────────────────
                  RoomPlayersCard(
                    players: playersList,
                    onPlayerLongPress: (targetPlayer) {
                      if (isHost && targetPlayer.id != currentUserId) {
                        unawaited(
                          PlayerActionsBottomSheet.show(
                            context,
                            player: targetPlayer,
                            onMakeHost: () {
                              unawaited(roomCubit.makeHost(targetPlayer.id));
                            },
                            onKickPlayer: () {
                              unawaited(roomCubit.kickPlayer(targetPlayer.id));
                            },
                          ),
                        );
                      }
                    },
                  ),
                  20.szH,
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
}

class RoomCodeCard extends StatelessWidget {
  final String title;
  final String roomCode;
  final VoidCallback? onTap;

  const RoomCodeCard({
    required this.title, required this.roomCode, super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap ??
          () {
            unawaited(Clipboard.setData(ClipboardData(text: roomCode)));
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).roomCodeCopied,
            );
          },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          border: Border.all(
            color: AppColors.yellowColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: getTextStyle().s20.bold.whiteColor,
              textAlign: TextAlign.center,
            ),
            10.szH,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  roomCode,
                  style: getTextStyle().s28.w700.yellowColor,
                  textAlign: TextAlign.center,
                ),
                10.szW,
                Icon(
                  Icons.copy_rounded,
                  size: 24.sp,
                  color: AppColors.yellowColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
}
