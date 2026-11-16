import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/text_scale_provider.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../../auth/viewmodel/sign_in_viewmodel.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsMenuView extends StatelessWidget {
  const SettingsMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final localeProvider = context.watch<LocaleProvider>();
    final textScaleProvider = context.watch<TextScaleProvider>();
    final langCode = localeProvider.locale.languageCode;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.settings),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuSeven', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          children: [
            // Dark Mode Switch
            Container(
              decoration: AppDecorations.cardDecoration(context),
              child: SwitchListTile(
                value: settingsVm.isDarkMode,
                activeTrackColor: AppColors.primary,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.mintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.dark_mode_rounded, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  langCode == 'en' ? 'Dark Theme' : 'الوضع الليلي (Dark Mode)',
                  style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.textDark),
                ),
                onChanged: (val) => settingsVm.toggleDarkMode(val),
              ),
            ),
            const SizedBox(height: 12),

            // Accent Color Blue/Green Switch
            Container(
              decoration: AppDecorations.cardDecoration(context),
              child: SwitchListTile(
                value: settingsVm.isBlueAccent,
                activeTrackColor: AppColors.blue,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.palette_rounded, color: AppColors.blue, size: 20),
                ),
                title: Text(
                  langCode == 'en' ? 'Blue Accent Color' : 'اللون الأزرق الثانوي البديل',
                  style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.textDark),
                ),
                onChanged: (val) => settingsVm.toggleBlueAccent(val),
              ),
            ),
            const SizedBox(height: 12),

            // Language Toggle Switch (English / Arabic)
            Container(
              decoration: AppDecorations.cardDecoration(context),
              child: SwitchListTile(
                value: langCode == 'en',
                activeTrackColor: AppColors.primary,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.mintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.language_rounded, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  langCode == 'en' ? 'English Language' : 'واجهة اللغة الإنجليزية',
                  style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.textDark),
                ),
                onChanged: (val) {
                  localeProvider.setLocale(val ? 'en' : 'ar');
                },
              ),
            ),
            const SizedBox(height: 12),

            // Push Notifications Switch
            Container(
              decoration: AppDecorations.cardDecoration(context),
              child: SwitchListTile(
                value: settingsVm.notificationsEnabled,
                activeTrackColor: AppColors.primary,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.orangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(AppIcons.notification, color: AppColors.orange, size: 20),
                ),
                title: Text(
                  langCode == 'en' ? 'Push Notifications' : 'تفعيل الإشعارات والتنبيهات الفورية',
                  style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.textDark),
                ),
                onChanged: (val) => settingsVm.toggleNotifications(val),
              ),
            ),
            const SizedBox(height: 16),

            // Font Scaling Slider Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: AppDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.mintSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.format_size_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        langCode == 'en' ? 'Text Scaling' : 'حجم خط النصوص في التطبيق',
                        style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.textDark),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(textScaleProvider.scale * 100).toInt()}%',
                          style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: textScaleProvider.scale,
                    min: 0.85,
                    max: 1.30,
                    divisions: 3,
                    activeColor: AppColors.primary,
                    inactiveColor: const Color(0xFFE2E8F0),
                    onChanged: (val) => textScaleProvider.setScale(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign out button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orange, width: 1.5),
                foregroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
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
              icon: const Icon(AppIcons.signOut, color: AppColors.orange, size: 20),
              label: Text(
                langCode == 'en' ? 'Sign Out' : 'تسجيل الخروج من الحساب',
                style: AppTextStyles.cairoBold(fontSize: 14.5, color: AppColors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
