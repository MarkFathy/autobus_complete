import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/user_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomPlayer {
  final String id;
  final String name;
  final String? photoUrl;
  final bool isHost;
  final bool isReady;

  const RoomPlayer({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isHost = false,
    this.isReady = false,
  });
}

class RoomPlayersCard extends StatelessWidget {
  final List<RoomPlayer> players;
  final int maxPlayers;
  final void Function(RoomPlayer player)? onPlayerLongPress;

  const RoomPlayersCard({
    super.key,
    required this.players,
    this.maxPlayers = 12,
    this.onPlayerLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Title & Player Counter Badge ──────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups_rounded,
                    color: AppColors.yellowColor,
                    size: 24.sp,
                  ),
                  8.szW,
                  Text(
                    S.of(context).players,
                    style: getTextStyle().s18.w700.whiteColor,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.yellowColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.yellowColor,
                    width: 1.w,
                  ),
                ),
                child: Text(
                  '${players.length}/$maxPlayers',
                  style: getTextStyle().s12.w700.yellowColor,
                ),
              ),
            ],
          ),
          16.szH,
          Divider(
            color: AppColors.greyColor.withValues(alpha: 0.2),
            height: 1,
          ),
          16.szH,

          // ── Joined Players Grid ──────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final player = players[index];
              return PlayerTileItem(
                player: player,
                onLongPress: onPlayerLongPress != null
                    ? () => onPlayerLongPress!(player)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlayerTileItem extends StatelessWidget {
  final RoomPlayer player;
  final VoidCallback? onLongPress;

  const PlayerTileItem({
    super.key,
    required this.player,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: player.isHost
                ? AppColors.yellowColor.withValues(alpha: 0.6)
                : AppColors.greyColor.withValues(alpha: 0.2),
            width: player.isHost ? 1.5.w : 1.w,
          ),
          boxShadow: player.isHost
              ? [
                  BoxShadow(
                    color: AppColors.yellowColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Avatar with King Crown Overlay for Host
            Stack(
              clipBehavior: Clip.none,
              children: [
                UserProfileAvatar(
                  radius: 20,
                  imageUrl: player.photoUrl,
                  borderColor: player.isHost
                      ? AppColors.yellowColor
                      : AppColors.greyColor,
                ),
                if (player.isHost)
                  Positioned(
                    top: -12.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Transform.rotate(
                        angle: -0.15,
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.yellowColor.withValues(alpha: 0.5),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.workspace_premium_rounded, // King Crown Icon 👑
                            color: AppColors.yellowColor,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            10.szW,

            // Player Name (Tap-to-Scroll Marquee) & Status Badge
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InteractivePlayerName(name: player.name),
                  4.szH,
                  if (player.isHost)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.yellowColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        S.of(context).host,
                        style: getTextStyle().s10.w700.yellowColor,
                      ),
                    )
                  else
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: player.isReady
                            ? AppColors.cyanColor.withValues(alpha: 0.2)
                            : AppColors.greyColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        player.isReady
                            ? S.of(context).ready
                            : S.of(context).unReady,
                        style: player.isReady
                            ? getTextStyle().s10.w700.cyanColor
                            : getTextStyle().s10.w500.greyColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InteractivePlayerName extends StatefulWidget {
  final String name;

  const InteractivePlayerName({
    super.key,
    required this.name,
  });

  @override
  State<InteractivePlayerName> createState() => _InteractivePlayerNameState();
}

class _InteractivePlayerNameState extends State<InteractivePlayerName> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  bool get _isArabicName {
    if (widget.name.trim().isEmpty) return false;
    final clean = widget.name.trimLeft();
    final code = clean.codeUnitAt(0);
    return code >= 0x0600 && code <= 0x06FF;
  }

  void _triggerMarqueeScroll() async {
    if (!_scrollController.hasClients) return;
    if (_isScrolling) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    setState(() {
      _isScrolling = true;
    });

    _scrollController.jumpTo(0.0);

    await _scrollController.animateTo(
      maxScroll,
      duration: Duration(
        milliseconds: (maxScroll * 35).clamp(1500, 4000).toInt(),
      ),
      curve: Curves.easeInOut,
    );

    await Future.delayed(const Duration(milliseconds: 700));

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }

    if (mounted) {
      setState(() {
        _isScrolling = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = _isArabicName ? TextDirection.rtl : TextDirection.ltr;

    return GestureDetector(
      onTap: _triggerMarqueeScroll,
      child: Directionality(
        textDirection: textDirection,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Text(
            widget.name,
            style: getTextStyle().s14.w700.whiteColor,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
