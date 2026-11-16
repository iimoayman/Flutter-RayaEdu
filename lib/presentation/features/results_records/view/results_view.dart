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

class ResultsView extends StatefulWidget {
  const ResultsView({Key? key}) : super(key: key);

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultsRecordsViewModel>().loadResults();
    });
  }

  Color _getEvaluationColor(String eval) {
    if (eval.contains('ممتاز') || eval.contains('جيد جداً') || eval.contains('ناجح')) {
      return AppColors.primary;
    } else if (eval.contains('راسب') || eval.contains('ضعيف')) {
      return AppColors.red;
    }
    return AppColors.orange;
  }

  Color _getEvaluationBg(String eval) {
    if (eval.contains('ممتاز') || eval.contains('جيد جداً') || eval.contains('ناجح')) {
      return AppColors.mintSurface;
    } else if (eval.contains('راسب') || eval.contains('ضعيف')) {
      return AppColors.red.withValues(alpha: 0.1);
    }
    return AppColors.orangeLight;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultsRecordsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final results = viewModel.resultsResponse?.resultsData ?? [];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.results),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuFour', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => viewModel.loadResults(),
        child: viewModel.isLoading
            ? const LoadingIndicatorWidget()
            : viewModel.errorMessage != null
                ? NoWifiWidget(onRetry: () => viewModel.loadResults())
                : results.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد نتائج معلنة حالياً')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = results[index];
                          final evalColor = _getEvaluationColor(item.evaluation);
                          final evalBg = _getEvaluationBg(item.evaluation);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: AppColors.mintSurface,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.grade_outlined,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              item.materialName,
                                              style: AppTextStyles.cairoBold(
                                                fontSize: 15,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: evalBg,
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: evalColor.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        item.evaluation,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 12.5,
                                          color: evalColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 13,
                                      color: AppColors.textLight,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.academicYearName} • ${item.termName}',
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.statusAlert.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.orangeLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.orangeBorder),
                                    ),
                                    child: Text(
                                      item.statusAlert,
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 11.5,
                                        color: AppColors.orangeDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
