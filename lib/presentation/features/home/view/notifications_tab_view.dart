import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../viewmodel/notifications_viewmodel.dart';

class NotificationsTabView extends StatefulWidget {
  const NotificationsTabView({Key? key}) : super(key: key);

  @override
  State<NotificationsTabView> createState() => _NotificationsTabViewState();
}

class _NotificationsTabViewState extends State<NotificationsTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Notifications' : 'الإشعارات والتنبيهات',
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.75),
              labelStyle: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
              unselectedLabelStyle: AppTextStyles.cairoMedium(fontSize: 14, color: Colors.white70),
              tabs: [
                Tab(text: AppStrings.get('notificationsFsessions', langCode)),
                Tab(text: AppStrings.get('notificationsFalerts', langCode)),
              ],
            ),
          ),
        ),
      ),
      body: viewModel.isLoading
          ? const LoadingIndicatorWidget()
          : TabBarView(
              controller: _tabController,
              children: [
                // Sessions Tab
                viewModel.sessions.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد إشعارات جديدة للمحاضرات')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: viewModel.sessions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = viewModel.sessions[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.mintSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    AppIcons.notification,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.content,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 14,
                                          color: AppColors.textDark,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            size: 13,
                                            color: AppColors.textLight,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.createdAt,
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
                              ],
                            ),
                          );
                        },
                      ),

                // Warnings Tab
                viewModel.warnings.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد إنذارات أكاديمية مسجلة')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: viewModel.warnings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = viewModel.warnings[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(
                              context,
                              border: Border.all(
                                color: AppColors.orangeBorder,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.orangeLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.orangeBorder),
                                  ),
                                  child: Lottie.asset(
                                    'assets/lottie/hey_you.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.statusAlert,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 14,
                                          color: AppColors.textDark,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 13,
                                            color: AppColors.textLight,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.termAcademicYearName} • ${item.termName}',
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
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
