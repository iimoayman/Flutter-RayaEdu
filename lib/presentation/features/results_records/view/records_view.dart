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

class RecordsView extends StatefulWidget {
  const RecordsView({Key? key}) : super(key: key);

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultsRecordsViewModel>().loadRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultsRecordsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final records = viewModel.records;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.records),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuSix', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => viewModel.loadRecords(),
        child: viewModel.isLoading
            ? const LoadingIndicatorWidget()
            : viewModel.errorMessage != null
                ? NoWifiWidget(onRetry: () => viewModel.loadRecords())
                : records.isEmpty
                    ? const EmptyStateWidget(
                        message: 'لا توجد بيانات مسجلة في السجل الأكاديمي')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final item = records[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: AppColors.mintSurface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        AppIcons.records,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.materialName,
                                            style: AppTextStyles.cairoBold(
                                              fontSize: 15.5,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${item.academicYear} • ${item.termName}',
                                            style: AppTextStyles.cairoRegular(
                                              fontSize: 12,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Divider(
                                  color: AppColors.borderSubtle,
                                  height: 1,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintSurface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.mintBorder),
                                      ),
                                      child: Text(
                                        'اللجنة: ${item.committeeNumber}',
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 12.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.orangeLight,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.orangeBorder),
                                      ),
                                      child: Text(
                                        'المكان: ${item.roomName}',
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 12.5,
                                          color: AppColors.orangeDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.time.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        'التوقيت: ${item.time}',
                                        style: AppTextStyles.cairoMedium(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
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
