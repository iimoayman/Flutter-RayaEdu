import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Notifications' : 'الإشعارات والتنبيهات',
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange,
          indicatorWeight: 3.5,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
          tabs: [
            Tab(text: AppStrings.get('notificationsFsessions', langCode)),
            Tab(text: AppStrings.get('notificationsFalerts', langCode)),
          ],
        ),
      ),
      body: viewModel.isLoading
          ? const LoadingIndicatorWidget()
          : TabBarView(
              controller: _tabController,
              children: [
                // Sessions
                viewModel.sessions.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد إشعارات جديدة للمحاضرات')
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: viewModel.sessions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, index) {
                          final item = viewModel.sessions[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(AppIcons.notification,
                                    color: AppColors.mainC, size: 26),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.content,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 14,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.createdAt,
                                        style: AppTextStyles.cairoMedium(
                                          fontSize: 12,
                                          color: AppColors.lightGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                // Warnings
                viewModel.warnings.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد إنذارات أكاديمية مسجلة')
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: viewModel.warnings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, index) {
                          final item = viewModel.warnings[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: AppColors.orange, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.statusAlert,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 14,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      Text(
                                        '${item.termAcademicYearName} - ${item.termName}',
                                        style: AppTextStyles.cairoMedium(
                                          fontSize: 12,
                                          color: AppColors.lightGray,
                                        ),
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
