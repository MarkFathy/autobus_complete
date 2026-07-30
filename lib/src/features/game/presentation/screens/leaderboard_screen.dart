import 'dart:convert';
import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardScreen extends StatelessWidget {
  final RoomEntity? room;

  const LeaderboardScreen({
    super.key,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider.value(
      value: sl<RoomCubit>(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          final liveRoom = sl<RoomCubit>().currentRoom;
          if (liveRoom?.status == 'waiting') {
            Go.offAllNamed(NamedRoutes.roomLobby);
          }
        },
        builder: (context, state) {
          final activeRoom = room ?? context.read<RoomCubit>().currentRoom;
          final isHost = activeRoom?.hostId == currentUserId;

          final List<RoomPlayerEntity> sortedPlayers = List.from(
            activeRoom?.players ?? _defaultPlayers,
          )..sort((a, b) => b.score.compareTo(a.score));

          final winner = sortedPlayers.isNotEmpty ? sortedPlayers[0] : null;
          final winnerTotal = winner?.score ?? 0;

          return PopScope(
            canPop: false,
            child: AppScaffold(
              appBar: CustomAppBar(
                showBackButton: false,
                title: Text(
                  S.of(context).finalResults,
                  style: getTextStyle().s20.w700.yellowColor,
                ),
              ),
              body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // ── WINNER SPOTLIGHT WITH LOTTIE BACKGROUND STACK ─────
                    if (winner != null)
                      SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Winner Lottie Animation Background
                            Positioned.fill(
                              child: Assets.lotties.winner.lottie(
                                fit: BoxFit.contain,
                              ),
                            ),

                            // Winner Avatar, Name & Score Overlay
                            Positioned(
                              top: 1.h,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Crown Lottie 
                                  Assets.lotties.crown.lottie(
                                    height: 40.h,
                                    width: 40.w,
                                    fit: BoxFit.contain,
                                  ),
                                  2.szH,

                                  // Winner Avatar
                                  _PlayerAvatar(
                                    photoUrl: winner.photoUrl,
                                    name: winner.name,
                                    radius: 34.r,
                                    borderColor: AppColors.yellowColor,
                                  ),
                                  6.szH,

                                  // Winner Name
                                  Text(
                                    winner.name,
                                    style: getTextStyle().s16.bold.yellowColor,
                                  ),
                                  4.szH,

                                  // Winner Total Points Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.yellowColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(color: AppColors.yellowColor),
                                    ),
                                    child: Text(
                                      '$winnerTotal pts',
                                      style: getTextStyle().s12.bold.yellowColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    12.szH,

                    // ── TABLE OF ALL PLAYERS (RANKINGS FROM 1ST TO LAST) ──────
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.yellowColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Table Header Row
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 36.w,
                                    child: Text(
                                      '#',
                                      style: getTextStyle().s12.bold.yellowColor,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  12.szW,
                                  Expanded(
                                    child: Text(
                                      isArabic ? 'اللاعب' : 'Player',
                                      style: getTextStyle().s12.bold.yellowColor,
                                    ),
                                  ),
                                  Text(
                                    isArabic ? 'المجموع الكلي' : 'Total Score',
                                    style: getTextStyle().s12.bold.yellowColor,
                                  ),
                                ],
                              ),
                            ),

                            // Table Content List of All Players
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: sortedPlayers.length,
                                separatorBuilder: (_, __) => const Divider(
                                  color: AppColors.greyColor,
                                  height: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final player = sortedPlayers[index];
                                  final rank = index + 1;
                                  final isWinnerPlayer = rank == 1;

                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                                    child: Row(
                                      children: [
                                        // Rank Badge
                                        Container(
                                          width: 32.w,
                                          height: 32.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _getRankColor(rank).withValues(alpha: 0.2),
                                            border: Border.all(color: _getRankColor(rank)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$rank',
                                              style: getTextStyle().s12.bold.copyWith(
                                                    color: _getRankColor(rank),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        12.szW,

                                        // Player Avatar
                                        _PlayerAvatar(
                                          photoUrl: player.photoUrl,
                                          name: player.name,
                                          radius: 16.r,
                                          borderColor: _getRankColor(rank),
                                        ),
                                        10.szW,

                                        // Player Name
                                        Expanded(
                                          child: Text(
                                            player.name,
                                            style: isWinnerPlayer
                                                ? getTextStyle().s14.bold.yellowColor
                                                : getTextStyle().s14.w500.whiteColor,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        // Total Score Badge
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.cyanColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12.r),
                                            border: Border.all(color: AppColors.cyanColor),
                                          ),
                                          child: Text(
                                            '${player.score} pts',
                                            style: getTextStyle().s12.bold.cyanColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.szH,

                    // ── PLAY AGAIN ACTION BUTTON / WAITING BANNER ───────────
                    if (isHost)
                      CustomButton(
                        text: S.of(context).playAgain,
                        onPressed: () {
                          sl<RoomCubit>().playAgain();
                        },
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.yellowColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isArabic
                                ? 'بانتظار الهوست لبدء اللعبة من جديد...'
                                : 'Waiting for Host to play again...',
                            style: getTextStyle().s14.w600.yellowColor,
                          ),
                        ),
                      ),
                    12.szH,
                  ],
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.yellowColor;
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.greyColor;
    }
  }

  List<RoomPlayerEntity> get _defaultPlayers => const [
        RoomPlayerEntity(id: '1', name: 'Player 1', score: 150, isHost: true),
        RoomPlayerEntity(id: '2', name: 'Player 2', score: 110, isHost: false),
        RoomPlayerEntity(id: '3', name: 'Player 3', score: 85, isHost: false),
      ];
}

class _PlayerAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;
  final Color borderColor;

  const _PlayerAvatar({
    required this.photoUrl,
    required this.name,
    required this.radius,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.w),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: borderColor.withValues(alpha: 0.2),
        backgroundImage: hasPhoto
            ? (photoUrl!.startsWith('data:image')
                ? MemoryImage(base64Decode(photoUrl!.split(',').last))
                : NetworkImage(photoUrl!) as ImageProvider)
            : null,
        child: !hasPhoto
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: (radius * 0.8).sp,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                ),
              )
            : null,
      ),
    );
  }
}
