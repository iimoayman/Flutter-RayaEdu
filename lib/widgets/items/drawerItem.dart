import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/theme/app_styles.dart';
import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';


class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.trailing,
    this.contentDescription,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? contentDescription;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    return Semantics(
      button: true,
      selected: selected,
      label: contentDescription ?? title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Material(
          color: selected ? AppColors.navItemSelected : Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: borderRadius,
            splashColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.04),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: AppColors.navIcons,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: navDrawerTextStyle.copyWith(
                        color: AppColors.navIcons,
                        fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}