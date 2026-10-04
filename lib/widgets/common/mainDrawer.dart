import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/widgets/common/drawerHeader.dart';
import 'package:rayaedu/widgets/items/drawerItem.dart';

enum DrawerSection { home, digitalId, notifications, about, settings, logout }


class MainDrawer extends StatefulWidget {
  const MainDrawer({
    super.key,
    this.current = DrawerSection.home,
    this.onItemSelected,
  });

  final DrawerSection current;

  final ValueChanged<DrawerSection>? onItemSelected;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late DrawerSection _current;

  @override
  void initState() {
    super.initState();
    _current = widget.current;
  }

  void _handleTap(DrawerSection section) {
    setState(() => _current = section);

    Navigator.of(context).pop();

    if (widget.onItemSelected != null) {
      widget.onItemSelected!(section);
    } else {
      _defaultNavigation(section);
    }
  }

  void _defaultNavigation(DrawerSection section) {
    switch (section) {
      case DrawerSection.home:
      case DrawerSection.digitalId:
      case DrawerSection.notifications:
      case DrawerSection.about:
      case DrawerSection.settings:
      case DrawerSection.logout:
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth =
        MediaQuery.of(context).size.width * 0.78; // ~78% on phones

    return Drawer(
      backgroundColor: AppColors.mainC,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      width: drawerWidth.clamp(210, 320).toDouble(),

      child: Semantics(
        label: 'Navigation drawer',
        container: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerItem(
                        icon: Icons.home_rounded,
                        title: 'Home',
                        selected: _current == DrawerSection.home,
                        onTap: () => _handleTap(DrawerSection.home),
                      ),
                      DrawerItem(
                        icon: Icons.badge_outlined,
                        title: 'Digital ID',
                        selected: _current == DrawerSection.digitalId,
                        onTap: () => _handleTap(DrawerSection.digitalId),
                      ),
                      DrawerItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        selected: _current == DrawerSection.notifications,
                        onTap: () =>
                            _handleTap(DrawerSection.notifications),
                      ),
                      DrawerItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        selected: _current == DrawerSection.settings,
                        onTap: () => _handleTap(DrawerSection.settings),
                      ),
                      DrawerItem(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        selected: _current == DrawerSection.about,
                        onTap: () => _handleTap(DrawerSection.about),
                      ),

                      const SizedBox(height: 12),
                      Divider(
                        color: AppColors.navIcons.withOpacity(0.18),
                        height: 1,
                      ),
                      const SizedBox(height: 12),

                      DrawerItem(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        selected: _current == DrawerSection.logout,
                        onTap: () => _handleTap(DrawerSection.logout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}