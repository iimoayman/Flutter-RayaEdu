import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/theme/appSizes.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key,
    required this.onTap,
    this.unreadCount = 0,
  });

  final VoidCallback onTap;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open notifications',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          // ── exact bell size, NOT + badge ─────────────────────────
          width: AppSizes.notifIcon,
          height: AppSizes.notifIcon,
          child: Stack(
            clipBehavior: Clip.none, // let the badge overflow
            children: [
              // ── bell fills the box ─────────────────────────────
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              // ── badge floats at the top-start of the bell ──────
              if (unreadCount > 0)
                Positioned(
                  top: -4,
                  left: -4,
                  child: Container(
                    width: AppSizes.badgeSize,
                    height: AppSizes.badgeSize,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC0404),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        fontSize: AppSizes.badgeTextSize,
                        color: AppColors.white,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}