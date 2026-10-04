import 'package:flutter/material.dart';
import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/theme/app_styles.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.subtitle,
    this.onTapAvatar,
  });

  final String photoUrl;
  final String name;
  final String subtitle;
  final VoidCallback? onTapAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTapAvatar,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle, // app:shapeAppearanceOverlay CircleImage
                color: Colors.white12,
              ),
              clipBehavior: Clip.antiAlias,
              child: photoUrl.isEmpty
                  ? const Icon(
                Icons.person,
                color: AppColors.navIcons,
                size: 30,
              )
                  : Image.network(
                photoUrl,
                fit: BoxFit.cover,
                // cookie / auth headers added in step 6
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: AppColors.navIcons,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: navDrawerTextStyle.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.navIcons.withOpacity(0.75),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}