import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';

class StudentGuideView extends StatelessWidget {
  const StudentGuideView({Key? key}) : super(key: key);

  final String _guideUrl =
      'https://drive.google.com/file/d/1eqMIpm9SvQtyCk282gxA7iu5s4G5mtV7/view';

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('stu_guide', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(AppIcons.userGuide, size: 80, color: AppColors.mainC),
              const SizedBox(height: 20),
              Text(
                langCode == 'en'
                    ? 'Official Student Guide & Code of Conduct'
                    : 'دليل الطالب الرسمي واللوائح الداخلية',
                style: AppTextStyles.cairoExtraBold(
                  fontSize: 18,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                langCode == 'en'
                    ? 'Tap below to read or download the complete student handbook.'
                    : 'اضغط بالأسفل لعرض وتحميل الدليل الكامل للوائح والأنظمة الدراسية.',
                style: AppTextStyles.cairoMedium(
                  fontSize: 14,
                  color: AppColors.lightGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainC,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse(_guideUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_browser_rounded, color: AppColors.white),
                label: Text(
                  langCode == 'en' ? 'Open Guide' : 'فتح الدليل',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
