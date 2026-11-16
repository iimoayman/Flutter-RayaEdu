import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../home/viewmodel/home_viewmodel.dart';

class OnlineSessionsTabView extends StatelessWidget {
  const OnlineSessionsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final huaweiSessions = homeVm.huaweiSessions;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Huawei Header Section
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.huawei.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.huawei.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_outlined, color: AppColors.huawei, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    langCode == 'en'
                        ? 'Huawei ICT Academy Sessions'
                        : 'جلسات أكاديمية هواوي للاتصالات',
                    style: AppTextStyles.cairoBold(
                      fontSize: 15,
                      color: AppColors.huawei,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Huawei Sessions List
          if (huaweiSessions.isNotEmpty) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: huaweiSessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                final session = huaweiSessions[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => UrlLauncherHelper.launchExternalUrl(
                      context,
                      session.link,
                      fallbackTitle: session.title,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.cardDecoration(context),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.huawei.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppColors.huawei,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.title,
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 14.5,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 13,
                                      color: AppColors.textLight,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${session.instructor} • ${session.time}',
                                      style: AppTextStyles.cairoRegular(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.primary,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
