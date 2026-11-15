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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultsRecordsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final results = viewModel.resultsResponse?.resultsData ?? [];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgColorLight,
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
        onRefresh: () => viewModel.loadResults(),
        child: viewModel.isLoading
            ? const LoadingIndicatorWidget()
            : viewModel.errorMessage != null
                ? NoWifiWidget(onRetry: () => viewModel.loadResults())
                : results.isEmpty
                    ? const EmptyStateWidget(message: 'لا توجد نتائج معلنة حالياً')
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = results[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.materialName,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 15,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainC.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.evaluation,
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 13,
                                          color: AppColors.mainC,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${item.academicYearName} - ${item.termName}',
                                  style: AppTextStyles.cairoMedium(
                                    fontSize: 12,
                                    color: AppColors.lightGray,
                                  ),
                                ),
                                if (item.statusAlert.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    item.statusAlert,
                                    style: AppTextStyles.cairoMedium(
                                      fontSize: 12,
                                      color: AppColors.orange,
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
