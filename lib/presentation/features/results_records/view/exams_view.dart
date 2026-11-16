import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../navigation/app_routes.dart';

class ExamsView extends StatelessWidget {
  const ExamsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.exams),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuThree', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.orangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(AppIcons.exam, size: 56, color: AppColors.orange),
                ),
                const SizedBox(height: 22),
                Text(
                  langCode == 'en' ? 'Examination Portal' : 'بوابة الامتحانات الرسمية',
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  langCode == 'en'
                      ? 'Exams and seating numbers are currently managed via the institute web portal. Please visit the official website for schedules and details.'
                      : 'جداول الامتحانات الرسمية وأرقام الجلوس واللجان تُدار عبر موقع المعهد الإلكتروني. يرجى زيارة الموقع للاطلاع على كافة التفاصيل والجداول المعتمدة.',
                  style: AppTextStyles.cairoRegular(
                    fontSize: 13.5,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.orange.withValues(alpha: 0.3),
                  ),
                  onPressed: () => UrlLauncherHelper.launchExternalUrl(
                    context,
                    'https://rayaedu.org',
                    fallbackTitle: langCode == 'en' ? 'Institute Website' : 'موقع المعهد',
                  ),
                  icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                  label: Text(
                    langCode == 'en' ? 'Visit Website' : 'زيارة موقع المعهد',
                    style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
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
