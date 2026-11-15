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
import '../../../navigation/app_routes.dart';
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
      backgroundColor: AppColors.bgColorLight,
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
          padding: const EdgeInsets.all(16.0),
          children: [
            // Dark Mode Switch
            Container(
              decoration: AppDecorations.cardDecoration(context),
              child: SwitchListTile(
                value: settingsVm.isDarkMode,
                activeThumbColor: AppColors.mainC,
                secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.mainC),
                title: Text(
                  langCode == 'en' ? 'Dark Theme' : 'الوضع الليلي',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
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
                activeThumbColor: AppColors.blue,
                secondary: const Icon(Icons.palette_rounded, color: AppColors.blue),
                title: Text(
                  langCode == 'en' ? 'Blue Accent Color' : 'اللون الأزرق الثانوي',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
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
                activeThumbColor: AppColors.mainC,
                secondary: const Icon(Icons.language_rounded, color: AppColors.mainC),
                title: Text(
                  langCode == 'en' ? 'English Language' : 'تفعيل اللغة الإنجليزية',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
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
                activeThumbColor: AppColors.mainC,
                secondary: const Icon(AppIcons.notification, color: AppColors.mainC),
                title: Text(
                  langCode == 'en' ? 'Push Notifications' : 'تفعيل الإشعارات الفورية',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
                ),
                onChanged: (val) => settingsVm.toggleNotifications(val),
              ),
            ),
            const SizedBox(height: 16),

            // Font Scaling Slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.format_size_rounded, color: AppColors.mainC),
                      const SizedBox(width: 10),
                      Text(
                        langCode == 'en' ? 'Text Scaling' : 'حجم الخط في التطبيق',
                        style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
                      ),
                      const Spacer(),
                      Text(
                        '${(textScaleProvider.scale * 100).toInt()}%',
                        style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.mainC),
                      ),
                    ],
                  ),
                  Slider(
                    value: textScaleProvider.scale,
                    min: 0.85,
                    max: 1.30,
                    divisions: 3,
                    activeColor: AppColors.mainC,
                    onChanged: (val) => textScaleProvider.setScale(val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
