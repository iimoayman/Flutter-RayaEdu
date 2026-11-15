import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/student_services_viewmodel.dart';

class StudentServiceView extends StatelessWidget {
  const StudentServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentServicesViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bgColorLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.studentServices),
      appBar: AppBar(
        title: Text(
          AppStrings.get('menuTwo', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewModel.loadServiceHistory(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick Service Cards
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('POReg', langCode),
                  icon: AppIcons.proofOfRegistration,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.proofOfRegistration),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('newCard', langCode),
                  icon: AppIcons.newCard,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.newCard),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('addNewStatement', langCode),
                  icon: AppIcons.statement,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.addNewStatement),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('stu_guide', langCode),
                  icon: AppIcons.userGuide,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.studentGuide),
                ),
                const SizedBox(height: 28),

                // History Section
                Text(
                  AppStrings.get('history_of_services', langCode),
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 18,
                    color: AppColors.mainC,
                  ),
                ),
                const SizedBox(height: 14),

                if (viewModel.isLoading)
                  const LoadingIndicatorWidget()
                else if (viewModel.servicesHistory.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: AppDecorations.cardDecoration(context),
                    child: Center(
                      child: Text(
                        langCode == 'en' ? 'No services requested yet' : 'لا توجد طلبات سابقة',
                        style: AppTextStyles.cairoMedium(fontSize: 14, color: AppColors.lightGray),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.servicesHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, index) {
                      final item = viewModel.servicesHistory[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.cardDecoration(context),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.service,
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 15,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.acceptDate,
                                    style: AppTextStyles.cairoMedium(
                                      fontSize: 12,
                                      color: AppColors.lightGray,
                                    ),
                                  ),
                                  if (item.addressed != null && item.addressed!.isNotEmpty)
                                    Text(
                                      'الجهة: ${item.addressed}',
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 12,
                                        color: AppColors.dGray,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: item.status.contains('موافقة') || item.status.contains('قبول')
                                    ? AppColors.lightGreen.withValues(alpha: 0.15)
                                    : AppColors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.status,
                                style: AppTextStyles.cairoBold(
                                  fontSize: 12,
                                  color: item.status.contains('موافقة') || item.status.contains('قبول')
                                      ? AppColors.lightGreen
                                      : AppColors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: AppDecorations.cardDecoration(context),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mainC, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
              ),
            ),
            const Icon(AppIcons.forwardArrow, color: AppColors.lightGray, size: 16),
          ],
        ),
      ),
    );
  }
}
