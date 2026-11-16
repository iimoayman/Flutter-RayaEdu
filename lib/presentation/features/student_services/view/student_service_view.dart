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
      backgroundColor: AppColors.bgLight,
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
          color: AppColors.primary,
          onRefresh: () => viewModel.loadServiceHistory(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick Service Cards
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('POReg', langCode),
                  subtitle: 'طلب استخراج شهادة إثبات قيد للجهات الرسمية',
                  icon: AppIcons.proofOfRegistration,
                  iconBg: AppColors.mintSurface,
                  iconColor: AppColors.primary,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.proofOfRegistration),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('newCard', langCode),
                  subtitle: 'طلب إصدار بطاقة جامعية بدل فاقد أو تالف',
                  icon: AppIcons.newCard,
                  iconBg: AppColors.orangeLight,
                  iconColor: AppColors.orange,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.newCard),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('addNewStatement', langCode),
                  subtitle: 'طلب بيان درجات دراسي معتمد',
                  icon: AppIcons.statement,
                  iconBg: AppColors.mintSurface,
                  iconColor: AppColors.primary,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.addNewStatement),
                ),
                const SizedBox(height: 12),
                _buildServiceActionCard(
                  context,
                  title: AppStrings.get('stu_guide', langCode),
                  subtitle: 'دليل الطالب واللوائح والأنظمة الدراسية',
                  icon: AppIcons.userGuide,
                  iconBg: AppColors.orangeLight,
                  iconColor: AppColors.orange,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.studentGuide),
                ),
                const SizedBox(height: 28),

                // History Section
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get('history_of_services', langCode),
                      style: AppTextStyles.cairoExtraBold(
                        fontSize: 18,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (viewModel.isLoading)
                  const LoadingIndicatorWidget()
                else if (viewModel.servicesHistory.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: AppDecorations.cardDecoration(context),
                    child: Center(
                      child: Text(
                        langCode == 'en' ? 'No services requested yet' : 'لا توجد طلبات سابقة مسجلة',
                        style: AppTextStyles.cairoMedium(fontSize: 14, color: AppColors.textMuted),
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.mintSurface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.assignment_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.service,
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 14.5,
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
                                        item.acceptDate,
                                        style: AppTextStyles.cairoRegular(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.addressed != null && item.addressed!.isNotEmpty && item.addressed != 'null') ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      'الجهة: ${item.addressed}',
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.status == '1'
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.orangeLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: item.status == '1'
                                      ? AppColors.mintBorder
                                      : AppColors.orangeBorder,
                                ),
                              ),
                              child: Text(
                                item.status == '1' ? 'تمت الموافقة' : 'قيد المراجعة',
                                style: AppTextStyles.cairoBold(
                                  fontSize: 11,
                                  color: item.status == '1' ? AppColors.primary : AppColors.orangeDark,
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
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.cardDecoration(context),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.cairoRegular(fontSize: 12, color: AppColors.textMuted),
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
                  size: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
