import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/locale_provider.dart';
import '../navigation/app_routes.dart';

class CustomDrawerWidget extends StatelessWidget {
  final String activeRoute;

  const CustomDrawerWidget({
    Key? key,
    required this.activeRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    final menuItems = [
      _DrawerItem(
        route: AppRoutes.home,
        titleKey: 'menuOne',
        icon: AppIcons.home,
      ),
      _DrawerItem(
        route: AppRoutes.studentServices,
        titleKey: 'menuTwo',
        icon: AppIcons.studentService,
      ),
      _DrawerItem(
        route: AppRoutes.exams,
        titleKey: 'menuThree',
        icon: AppIcons.exam,
      ),
      _DrawerItem(
        route: AppRoutes.results,
        titleKey: 'menuFour',
        icon: AppIcons.results,
      ),
      _DrawerItem(
        route: AppRoutes.resultsOnline,
        titleKey: 'menuFive',
        icon: AppIcons.onlineResults,
      ),
      _DrawerItem(
        route: AppRoutes.records,
        titleKey: 'menuSix',
        icon: AppIcons.records,
      ),
      _DrawerItem(
        route: AppRoutes.settings,
        titleKey: 'menuSeven',
        icon: AppIcons.settings,
      ),
      _DrawerItem(
        route: 'sign_out_action',
        titleKey: 'menuEight',
        icon: AppIcons.signOut,
        isDestructive: true,
      ),
    ];

    return Drawer(
      backgroundColor: AppColors.mainC,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.get('rayatxt', langCode),
                style: AppTextStyles.cairoExtraBold(
                  fontSize: 22,
                  color: AppColors.white,
                ),
              ),
              Text(
                AppStrings.get('slangInEdu', langCode),
                style: AppTextStyles.cairoMedium(
                  fontSize: 13,
                  color: AppColors.hello,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (ctx, index) {
                    final item = menuItems[index];
                    final isSelected = activeRoute == item.route;

                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.white.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color: item.isDestructive
                              ? AppColors.orange
                              : (isSelected ? AppColors.white : AppColors.ico),
                          size: 24,
                        ),
                        title: Text(
                          AppStrings.get(item.titleKey, langCode),
                          style: AppTextStyles.cairoBold(
                            fontSize: 15,
                            color: item.isDestructive
                                ? AppColors.orange
                                : (isSelected
                                    ? AppColors.white
                                    : AppColors.white.withValues(alpha: 0.85)),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(); // Close drawer
                          if (item.route == 'sign_out_action') {
                            _showSignOutDialog(context, langCode);
                          } else if (activeRoute != item.route) {
                            Navigator.of(context).pushReplacementNamed(item.route);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, String langCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppStrings.get('menuEight', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.black),
          textAlign: TextAlign.center,
        ),
        content: Text(
          langCode == 'en'
              ? 'Are you sure you want to sign out?'
              : 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: AppTextStyles.cairoMedium(fontSize: 15, color: AppColors.dGray),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              langCode == 'en' ? 'Cancel' : 'إلغاء',
              style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.lightGray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.signIn,
                (route) => false,
              );
            },
            child: Text(
              langCode == 'en' ? 'Sign Out' : 'تسجيل الخروج',
              style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String route;
  final String titleKey;
  final IconData icon;
  final bool isDestructive;

  _DrawerItem({
    required this.route,
    required this.titleKey,
    required this.icon,
    this.isDestructive = false,
  });
}
