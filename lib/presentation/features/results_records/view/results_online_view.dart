import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/empty_state_widget.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/no_wifi_widget.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/results_records_viewmodel.dart';

class ResultsOnlineView extends StatefulWidget {
  const ResultsOnlineView({Key? key}) : super(key: key);

  @override
  State<ResultsOnlineView> createState() => _ResultsOnlineViewState();
}

class _ResultsOnlineViewState extends State<ResultsOnlineView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultsRecordsViewModel>().loadOnlineResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultsRecordsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final list = viewModel.onlineResults;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.resultsOnline),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuFive', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => viewModel.loadOnlineResults(),
        child: viewModel.isLoading
            ? const LoadingIndicatorWidget()
            : viewModel.errorMessage != null
                ? NoWifiWidget(onRetry: () => viewModel.loadOnlineResults())
                : list.isEmpty
                    ? const EmptyStateWidget(
                        message: 'لا توجد نتائج اختبارات إلكترونية مسجلة')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = list[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.mintSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    AppIcons.onlineResults,
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
                                        item.materialName,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 15,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 12,
                                            color: AppColors.textLight,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.academicYear} • ${item.termDisplay}',
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.orangeLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.orangeBorder),
                                  ),
                                  child: Text(
                                    '${item.totalDegree} / ${item.maxDegree}',
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 14,
                                      color: AppColors.orangeDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
