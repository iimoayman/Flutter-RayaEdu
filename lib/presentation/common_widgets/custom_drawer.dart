import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/locale_provider.dart';
import '../features/auth/viewmodel/sign_in_viewmodel.dart';
import '../navigation/app_routes.dart';
import 'status_dialogs.dart';

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
        route: AppRoutes.studentGuide,
        titleKey: 'menuStudentGuide',
        icon: Icons.menu_book_rounded,
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
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.horizontal(
          end: Radius.circular(28),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Logo & Branding
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_raster.webp',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('rayatxt', langCode),
                              style: AppTextStyles.cairoBold(
                                fontSize: 18,
                                color: AppColors.white,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.orange.withValues(alpha: 0.6),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                AppStrings.get('slangInEdu', langCode),
                                style: AppTextStyles.cairoMedium(
                                  fontSize: 10,
                                  color: AppColors.orangeLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.white.withValues(alpha: 0.12),
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 12),

                // Navigation Items List
                Expanded(
                  child: ListView.separated(
                    itemCount: menuItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (ctx, index) {
                      final item = menuItems[index];
                      final isSelected = activeRoute == item.route;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.white
                              : (item.isDestructive
                                  ? AppColors.orange.withValues(alpha: 0.12)
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? Border.all(color: AppColors.mintBorder, width: 1)
                              : (item.isDestructive
                                  ? Border.all(
                                      color: AppColors.orange.withValues(alpha: 0.3),
                                      width: 1,
                                    )
                                  : null),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              if (item.route == 'sign_out_action') {
                                _showSignOutDialog(context, langCode);
                              } else if (activeRoute != item.route) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacementNamed(item.route);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.mintSurface
                                          : (item.isDestructive
                                              ? AppColors.orange.withValues(alpha: 0.2)
                                              : Colors.white.withValues(alpha: 0.08)),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      item.icon,
                                      size: 20,
                                      color: item.isDestructive
                                          ? AppColors.orange
                                          : (isSelected
                                              ? AppColors.primary
                                              : Colors.white.withValues(alpha: 0.9)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      AppStrings.get(item.titleKey, langCode),
                                      style: AppTextStyles.cairoBold(
                                        fontSize: 14,
                                        color: item.isDestructive
                                            ? AppColors.orangeLight
                                            : (isSelected
                                                ? AppColors.primaryDark
                                                : Colors.white.withValues(alpha: 0.92)),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Version Footer
                Center(
                  child: Text(
                    'Raya Educational Portal • v2.0',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, String langCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orangeLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orangeBorder, width: 1),
              ),
              child: const Icon(
                AppIcons.signOut,
                size: 36,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.get('menuEight', langCode),
              style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.textDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              langCode == 'en'
                  ? 'Are you sure you want to sign out?'
                  : 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              style: AppTextStyles.cairoMedium(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderSubtle, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    langCode == 'en' ? 'Cancel' : 'إلغاء',
                    style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    StatusDialogs.showLoading(context);
                    try {
                      await context.read<SignInViewModel>().signOut();
                    } catch (_) {}
                    if (context.mounted) {
                      StatusDialogs.hide(context);
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                        AppRoutes.signIn,
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    langCode == 'en' ? 'Sign Out' : 'تسجيل الخروج',
                    style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
                  ),
                ),
              ),
            ],
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
