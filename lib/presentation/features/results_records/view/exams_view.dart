import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
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
      backgroundColor: AppColors.bgColorLight,
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
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AppIcons.exam, size: 70, color: AppColors.orange),
                const SizedBox(height: 20),
                Text(
                  langCode == 'en'
                      ? 'Exams are currently managed via the institute web portal. Please visit the official website for schedules and seating numbers.'
                      : 'الامتحانات غير متوفرة على التطبيق حالياً، يرجى زيارة الموقع الإلكتروني الرسمي للمعهد للاطلاع على الجداول وأرقام الجلوس.',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.dGray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
