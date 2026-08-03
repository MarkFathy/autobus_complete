import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/user_profile_avatar.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/room_players_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerActionsBottomSheet extends StatelessWidget {
  final RoomPlayer player;
  final VoidCallback onMakeHost;
  final VoidCallback onKickPlayer;

  const PlayerActionsBottomSheet({
    required this.player, required this.onMakeHost, required this.onKickPlayer, super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required RoomPlayer player,
    required VoidCallback onMakeHost,
    required VoidCallback onKickPlayer,
  }) => showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlayerActionsBottomSheet(
        player: player,
        onMakeHost: onMakeHost,
        onKickPlayer: onKickPlayer,
      ),
    );

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Player Header Info ───────────────────────────────────
          UserProfileAvatar(
            radius: 28,
            imageUrl: player.photoUrl,
          ),
          12.szH,
          Text(
            player.name,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),
          20.szH,
          Divider(
            color: context.colors.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          16.szH,

          // ── Action 1: Make Host ───────────────────────────────────
          Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(14.r),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: context.colors.primary.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: context.colors.primary,
                  size: 22.sp,
                ),
              ),
              title: Text(
                S.of(context).makeHost,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onMakeHost();
              },
            ),
          ),
          12.szH,

          // ── Action 2: Kick Player ─────────────────────────────────
          Material(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(14.r),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: context.colors.secondary.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: context.colors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_remove_rounded,
                  color: context.colors.secondary,
                  size: 22.sp,
                ),
              ),
              title: Text(
                S.of(context).kickPlayer,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onKickPlayer();
              },
            ),
          ),
          10.szH,
        ],
      ),
    );
}
