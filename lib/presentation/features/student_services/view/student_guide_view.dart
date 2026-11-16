import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';

class StudentGuideView extends StatelessWidget {
  const StudentGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Student Guide' : 'دليل الطالب',
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.mintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    'assets/lottie/books.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  langCode == 'en'
                      ? 'Official Student Guide & Regulations'
                      : 'دليل الطالب الرسمي واللوائح الداخلية',
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  langCode == 'en'
                      ? 'Tap below to read the comprehensive handbook on the official Raya portal.'
                      : 'اضغط بالأسفل لعرض وتحميل الدليل الكامل للوائح والأنظمة الدراسية لمعهد راية عبر البوابة الرسمية.',
                  style: AppTextStyles.cairoRegular(
                    fontSize: 13.5,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.mintSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.mintBorder),
                  ),
                  child: Text(
                    UrlLauncherHelper.studentGuideUrl,
                    style: AppTextStyles.cairoMedium(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.orange.withValues(alpha: 0.3),
                    ),
                    onPressed: () => UrlLauncherHelper.launchStudentGuide(context),
                    icon: const Icon(Icons.open_in_browser_rounded, color: AppColors.white, size: 20),
                    label: Text(
                      langCode == 'en' ? 'Open Official Guide' : 'فتح دليل الطالب الرسمي',
                      style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
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
}
