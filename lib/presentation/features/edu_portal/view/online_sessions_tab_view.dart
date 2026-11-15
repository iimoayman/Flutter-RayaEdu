import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../home/viewmodel/home_viewmodel.dart';

class OnlineSessionsTabView extends StatelessWidget {
  const OnlineSessionsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final huaweiSessions = homeVm.huaweiSessions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Huawei Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.huawei.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.huawei.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_outlined, color: AppColors.huawei, size: 32),
                const SizedBox(width: 12),
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
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                final session = huaweiSessions[index];
                return InkWell(
                  onTap: () => _openUrl(session.link),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: AppDecorations.cardDecoration(context),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.huawei.withValues(alpha: 0.12),
                          radius: 22,
                          child: const Icon(Icons.play_circle_fill_rounded,
                              color: AppColors.huawei),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.title,
                                style: AppTextStyles.cairoBold(
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${session.instructor} - ${session.time}',
                                style: AppTextStyles.cairoMedium(
                                  fontSize: 12,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(AppIcons.forwardArrow,
                            color: AppColors.lightGray, size: 16),
                      ],
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

  void _openUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
