import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
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
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.3),
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
            style: getTextStyle().s18.bold.whiteColor,
            textAlign: TextAlign.center,
          ),
          20.szH,
          Divider(
            color: AppColors.greyColor.withValues(alpha: 0.2),
            height: 1,
          ),
          16.szH,

          // ── Action 1: Make Host ───────────────────────────────────
          Material(
            color: AppColors.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: AppColors.yellowColor.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.yellowColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.yellowColor,
                  size: 22.sp,
                ),
              ),
              title: Text(
                S.of(context).makeHost,
                style: getTextStyle().s14.w700.yellowColor,
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
            color: AppColors.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(
                  color: AppColors.redColor.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.redColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_remove_rounded,
                  color: AppColors.redColor,
                  size: 22.sp,
                ),
              ),
              title: Text(
                S.of(context).kickPlayer,
                style: getTextStyle().s14.w700.redColor,
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
