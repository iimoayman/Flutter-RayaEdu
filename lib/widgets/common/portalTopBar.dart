import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rayaedu/model/data/myData.dart';
import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/theme/appSizes.dart';
import 'package:rayaedu/widgets/common/notificationButton.dart';
import 'package:rayaedu/widgets/common/studentAvatar.dart';

class PortalTopBar extends StatelessWidget {
  const PortalTopBar({
    super.key,
    required this.onOpenDrawer,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.student,
    required this.unreadCount,
  });

  final VoidCallback onOpenDrawer;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final MyData? student;
  final int unreadCount;

  /// Message shown when a disabled action is tapped.
  static const String _notAllowedMsg = 'غير مسموح حاليا';

  /// Short alert — SnackBar that auto-dismisses quickly.
  void _showNotAllowed(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    // Hide any previous SnackBar so rapid taps don't queue up.
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: const Text(
          _notAllowedMsg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainC,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── profile avatar ────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              right: AppSizes.mainImgProfileMarginStart,
            ),
            child: Semantics(
              button: true,
              label: 'Open digital ID',
              child: StudentAvatar(
                data: student,
                onTap: () => _showNotAllowed(context),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // ── notifications ─────────────────────────────────────
          NotificationButton(
            onTap: () => _showNotAllowed(context),
            unreadCount: unreadCount,
          ),

          const Spacer(),

          // ── hamburger / drawer ────────────────────────────────
          Semantics(
            button: true,
            label: 'Open drawer',
            child: GestureDetector(
              onTap: () => _showNotAllowed(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.topLeftIconMarginEnd,
                ),
                child: Hero(
                  tag: 'Logo',
                  child: SvgPicture.asset(
                    'assets/icons/list.svg',
                    width: AppSizes.topLeftIcon - 10,
                    height: AppSizes.topLeftIcon - 10,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}