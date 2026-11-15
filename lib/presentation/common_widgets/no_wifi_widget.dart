import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_styles.dart';

class NoWifiWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String langCode;

  const NoWifiWidget({
    Key? key,
    required this.onRetry,
    this.langCode = 'ar',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.mainC.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.wifiOff,
                size: 70,
                color: AppColors.mainC,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.get('no_internet_title', langCode),
              style: AppTextStyles.cairoBold(
                fontSize: 18,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.get('no_internet_body', langCode),
              style: AppTextStyles.cairoMedium(
                fontSize: 14,
                color: AppColors.lightGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(AppIcons.refresh, color: AppColors.white),
              label: Text(
                langCode == 'en' ? 'Retry' : 'إعادة المحاولة',
                style: AppTextStyles.cairoBold(
                  fontSize: 15,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainC,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
