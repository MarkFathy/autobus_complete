import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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

  const RoomPlayer({required this.id, required this.name, this.photoUrl, this.isHost = false, this.isReady = false});
}

class RoomPlayersCard extends StatelessWidget {
  final List<RoomPlayer> players;
  final int maxPlayers;
  final void Function(RoomPlayer player)? onPlayerLongPress;

  const RoomPlayersCard({required this.players, super.key, this.maxPlayers = 12, this.onPlayerLongPress});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
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
                Icon(Icons.groups_rounded, color: context.colors.primary, size: 24.sp),
                8.szW,
                Text(
                  S.of(context).players,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.colors.primary, width: 1.w),
              ),
              child: Text(
                '${players.length}/$maxPlayers',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        16.szH,
        Divider(color: context.colors.outline.withValues(alpha: 0.2), height: 1),
        16.szH,

        // ── Joined Players Grid ──────────────────────────────────────
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final player = players[index];
            return PlayerTileItem(
              player: player,
              onLongPress: onPlayerLongPress != null ? () => onPlayerLongPress!(player) : null,
            );
          },
        ),
      ],
    ),
  );
}

class PlayerTileItem extends StatelessWidget {
  final RoomPlayer player;
  final VoidCallback? onLongPress;

  const PlayerTileItem({required this.player, super.key, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    const cyanColor = Color(0xFF00E5FF);
    final isNonHostReady = !player.isHost && player.isReady;

    return GestureDetector(
      onTap: onLongPress,
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar + Host Crown Overlay + Cyan Ready Ring/Glow
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Avatar with Ready (Cyan glow) or Host border
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: isNonHostReady
                      ? [BoxShadow(color: cyanColor.withValues(alpha: 0.6), blurRadius: 10.r, spreadRadius: 2.r)]
                      : (player.isHost
                            ? [BoxShadow(color: context.colors.primary.withValues(alpha: 0.3), blurRadius: 6.r)]
                            : []),
                ),
                child: UserProfileAvatar(
                  radius: 22,
                  imageUrl: player.photoUrl,
                  borderWidth: isNonHostReady ? 2.5 : (player.isHost ? 2 : 1),
                  borderColor: isNonHostReady
                      ? cyanColor
                      : (player.isHost ? context.colors.primary : context.colors.outline.withValues(alpha: 0.3)),
                ),
              ),

              // Host Crown Icon Badge above Avatar 👑
              if (player.isHost)
                Positioned(
                  top: -10.h,
                  child: Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: context.colors.primary.withValues(alpha: 0.4), blurRadius: 4.r)],
                    ),
                    child: Icon(Icons.workspace_premium_rounded, color: context.colors.primary, size: 16.sp),
                  ),
                ),
            ],
          ),
          6.szH,

          // Player Name Below Avatar
          InteractivePlayerName(name: player.name),
        ],
      ),
    );
  }
}

class InteractivePlayerName extends StatefulWidget {
  final String name;

  const InteractivePlayerName({required this.name, super.key});

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
      duration: Duration(milliseconds: (maxScroll * 35).clamp(1500, 4000).toInt()),
      curve: Curves.easeInOut,
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
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
      child: Center(
        child: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Text(
              widget.name,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
