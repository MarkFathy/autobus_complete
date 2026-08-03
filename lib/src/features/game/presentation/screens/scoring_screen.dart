import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:autobus_complete/src/core/widgets/custom_app_bar.dart';
import 'package:autobus_complete/src/core/widgets/user_profile_avatar.dart';
import 'package:autobus_complete/src/features/game/presentation/widgets/non_host_waiting_banner.dart';
import 'package:autobus_complete/src/features/game/presentation/widgets/score_badge.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_cubit.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoringScreen extends StatefulWidget {
  final RoomEntity? room;
  final Map<String, Map<String, String>>? playerAnswers; // {playerId: {categoryId: answer}}

  const ScoringScreen({
    super.key,
    this.room,
    this.playerAnswers,
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  // Local fallback scores map if Firestore stream has not populated yet
  final Map<String, Map<String, int>> _localScores = {};

  String _getAnswerForPlayer(RoomEntity? room, String playerId, String catId) {
    // 1. Check live Firestore room roundAnswers
    final roomAns = room?.roundAnswers[playerId]?[catId];
    if (roomAns != null && roomAns.isNotEmpty) return roomAns;

    // 2. Check widget.playerAnswers if passed directly
    final widgetAns = widget.playerAnswers?[playerId]?[catId];
    if (widgetAns != null && widgetAns.isNotEmpty) return widgetAns;

    return '';
  }

  int _getScoreForPlayer(RoomEntity? room, String playerId, String catId) {
    final answer = _getAnswerForPlayer(room, playerId, catId);
    if (answer.trim().isEmpty) return 0; // Empty field always receives 0 points

    // 1. Read real-time score from Firestore roundScores
    final firestoreScore = room?.roundScores[playerId]?[catId];
    if (firestoreScore != null) return firestoreScore;

    // 2. Local fallback
    return _localScores[playerId]?[catId] ?? 10;
  }

  int _calculatePlayerTotal(RoomEntity? room, String playerId, List<RoomCategoryEntity> categories) {
    var total = 0;
    for (final cat in categories) {
      total += _getScoreForPlayer(room, playerId, cat.id);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider.value(
      value: sl<RoomCubit>(),
      child: BlocConsumer<RoomCubit, RoomState>(
        listener: (context, state) {
          final room = sl<RoomCubit>().currentRoom;
          if (room?.status == 'playing') {
            unawaited(Go.offNamed(NamedRoutes.countdown));
          } else if (room?.status == 'finished') {
            unawaited(Go.offNamed(NamedRoutes.leaderboard));
          }
        },
        builder: (context, state) {
          final roomCubit = context.read<RoomCubit>();
          final activeRoom = widget.room ?? roomCubit.currentRoom;
          final isHost = activeRoom?.hostId == currentUserId;
          final categories = RoomCategoryEntity.getOrderedCategories(activeRoom?.categories);
          final players = activeRoom?.players ?? _defaultPlayers;
          final currentRound = activeRoom?.currentRound ?? 1;
          final totalRounds = activeRoom?.rounds ?? 5;

          return PopScope(
            canPop: false,
            child: AppScaffold(
              appBar: CustomAppBar(
                showBackButton: false,
                title: Text(
                  S.of(context).scoringTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // Round Header Badge
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: context.colors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${S.of(context).round} $currentRound/$totalRounds',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            '${S.of(context).currentLetter}: ${activeRoom?.currentLetter ?? 'أ'}',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colors.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.szH,

                    // Evaluation Table List of Players (Real-time Stream Synced)
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: players.length,
                        itemBuilder: (context, pIndex) {
                          final player = players[pIndex];
                          final playerTotal = _calculatePlayerTotal(activeRoom, player.id, categories);

                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.colors.primary.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Player Header Row (Cumulative Total Score Across All Rounds)
                                Row(
                                  children: [
                                    UserProfileAvatar(
                                      radius: 16,
                                      imageUrl: player.photoUrl,
                                    ),
                                    10.szW,
                                    Expanded(
                                      child: Text(
                                        player.name,
                                        style: context.textTheme.titleMedium?.copyWith(
                                          color: context.colors.onSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Total Cumulative Game Score Badge (Previous Rounds + Current Round)
                                    ScoreBadge(
                                      label: '${S.of(context).roundTotal}: ${player.score + playerTotal}',
                                    ),
                                  ],
                                ),
                                12.szH,
                                Divider(color: context.colors.outline, height: 1),
                                12.szH,

                                // Categories Answers & Score Buttons
                                ...categories.map((cat) {
                                  final rawAnswer = _getAnswerForPlayer(activeRoom, player.id, cat.id);
                                  final isEmpty = rawAnswer.trim().isEmpty;
                                  final currentScore = _getScoreForPlayer(activeRoom, player.id, cat.id);

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Row(
                                      children: [
                                        Text(cat.icon, style: TextStyle(fontSize: 16.sp)),
                                        6.szW,
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cat.getLocalizedName(context),
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: context.colors.onSurfaceVariant,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              2.szH,
                                              Text(
                                                isEmpty ? S.of(context).noAnswerGiven : rawAnswer,
                                                style: isEmpty
                                                    ? context.textTheme.bodySmall?.copyWith(
                                                        color: context.colors.secondary,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                      )
                                                    : context.textTheme.bodyMedium?.copyWith(
                                                        color: context.colors.onSurface,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14.sp,
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Score Controls (0, 5, 10)
                                        if (isEmpty)
                                          // Automatic 0 badge for empty answer
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: context.colors.secondaryContainer,
                                              borderRadius: BorderRadius.circular(8.r),
                                              border: Border.all(color: context.colors.secondary),
                                            ),
                                            child: Text(
                                              '0',
                                              style: context.textTheme.labelMedium?.copyWith(
                                                color: context.colors.secondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          )
                                        else if (isHost)
                                          // Host interactive 0, 5, 10 score picker (Syncs to Firestore Stream)
                                          Row(
                                            children: [0, 5, 10].map((scoreVal) {
                                              final isSelected = currentScore == scoreVal;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _localScores[player.id] ??= {};
                                                    _localScores[player.id]![cat.id] = scoreVal;
                                                  });
                                                  // Broadcast to Firestore Stream so all players see the update!
                                                  unawaited(
                                                    sl<RoomCubit>().updateCategoryScore(
                                                      playerId: player.id,
                                                      categoryId: cat.id,
                                                      score: scoreVal,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 4.w),
                                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? context.colors.primary
                                                        : context.colors.surface,
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? context.colors.primary
                                                          : context.colors.outline.withValues(alpha: 0.3),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '$scoreVal',
                                                    style: isSelected
                                                        ? context.textTheme.labelMedium?.copyWith(
                                                            color: context.colors.onPrimary,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.sp,
                                                          )
                                                        : context.textTheme.labelMedium?.copyWith(
                                                            color: context.colors.onSurface,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.sp,
                                                          ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        else
                                          // Non-Host live stream view of score assigned by Host
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: context.colors.primaryContainer,
                                              borderRadius: BorderRadius.circular(8.r),
                                              border: Border.all(color: context.colors.primary),
                                            ),
                                            child: Text(
                                              '$currentScore',
                                              style: context.textTheme.labelMedium?.copyWith(
                                                color: context.colors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),

                                4.szH,
                                Divider(color: context.colors.outline, height: 1),
                                10.szH,

                                // Round Score Footer (Below Last Answer)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${S.of(context).round} Score',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: context.colors.primaryContainer,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: context.colors.primary),
                                      ),
                                      child: Text(
                                        '${S.of(context).round}: $playerTotal',
                                        style: context.textTheme.labelMedium?.copyWith(
                                          color: context.colors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    12.szH,

                    // Host Navigation Button (Next Round / End Game)
                    if (isHost)
                      CustomButton(
                        text: currentRound < totalRounds
                            ? S.of(context).nextRound
                            : S.of(context).endGame,
                        onPressed: () {
                          if (currentRound < totalRounds) {
                            unawaited(sl<RoomCubit>().startNextRound());
                          } else {
                            unawaited(sl<RoomCubit>().endGame());
                          }
                        },
                      )
                    else
                      NonHostWaitingBanner(
                        text: S.of(context).waitingForOtherPlayers,
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

  List<RoomPlayerEntity> get _defaultPlayers => [
        const RoomPlayerEntity(id: '1', name: 'Player 1', isHost: true),
        const RoomPlayerEntity(id: '2', name: 'Player 2'),
      ];
}
