import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/typewriter_text.dart';
import '../../../navigation/app_routes.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../viewmodel/edu_portal_viewmodel.dart';

class EduPortalTabView extends StatefulWidget {
  const EduPortalTabView({Key? key}) : super(key: key);

  @override
  State<EduPortalTabView> createState() => _EduPortalTabViewState();
}

class _EduPortalTabViewState extends State<EduPortalTabView> {
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final student = homeVm.studentData;
    final achievements = homeVm.achievements;
    final materials = homeVm.materials;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => homeVm.loadHomeData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Welcome & Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: student != null && student.photoUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Image.asset(
                                'assets/images/profile.webp',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (_, __, ___) => Image.asset(
                                'assets/images/profile.webp',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/profile.webp',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoopingTypeWriterText(
                          texts: [
                            AppStrings.get('welcome_back', langCode),
                            AppStrings.get('slangInEdu', langCode),
                          ],
                          style: AppTextStyles.cairoBold(
                            fontSize: 12,
                            color: AppColors.orangeLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          student?.name ?? 'طالب معهد راية',
                          style: AppTextStyles.cairoExtraBold(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${AppStrings.get('stu_id', langCode)}: ${student?.code ?? 'غير متوفر'}',
                            style: AppTextStyles.cairoMedium(
                              fontSize: 11,
                              color: AppColors.mintSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Supabase Announcements Banners Carousel
            if (homeVm.banners.isNotEmpty) ...[
              SizedBox(
                height: 145,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: homeVm.banners.length,
                  itemBuilder: (ctx, index) {
                    final banner = homeVm.banners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderSubtle, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: banner.img.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: banner.img,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Center(
                                  child: Text(
                                    AppStrings.get('portalOfRaya', langCode),
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  AppStrings.get('portalOfRaya', langCode),
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 15,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SmoothPageIndicator(
                  controller: _bannerController,
                  count: homeVm.banners.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.orange,
                    dotColor: Color(0xFFCBD5E1),
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3,
                    spacing: 5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Quick Actions: Campus Location & QR Scanner
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.location),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.22),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(AppIcons.location, color: AppColors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              AppStrings.get('WhereIsIt', langCode),
                              style: AppTextStyles.cairoBold(
                                fontSize: 13,
                                color: AppColors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.qrScan),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orange.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(AppIcons.qr, color: AppColors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              AppStrings.get('ScanQr', langCode),
                              style: AppTextStyles.cairoBold(
                                fontSize: 13,
                                color: AppColors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Quiz & Exam Statistics Cards (Total Exams & Solved Exams)
            Row(
              children: [
                // 1. Total Quizzes Card
                Expanded(
                  child: Container(
                    decoration: AppDecorations.cardDecoration(context),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.exams),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.orangeLight,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.orangeBorder),
                                    ),
                                    child: const Icon(
                                      AppIcons.exam,
                                      color: AppColors.orange,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      langCode == 'en' ? 'Total' : 'الكلي',
                                      style: AppTextStyles.cairoBold(
                                        fontSize: 10.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  '${achievements?.countExamChapters ?? 0}',
                                  style: AppTextStyles.cairoExtraBold(
                                    fontSize: 22,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.get('exam_num', langCode),
                                style: AppTextStyles.cairoBold(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Solved / Completed Quizzes Card
                Expanded(
                  child: Container(
                    decoration: AppDecorations.cardDecoration(context),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.exams),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.mintSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.mintBorder),
                                    ),
                                    child: const Icon(
                                      Icons.task_alt_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  if ((achievements?.countExamChapters ?? 0) > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        '${(((achievements?.countExamChaptersDone ?? 0) / (achievements?.countExamChapters ?? 1)) * 100).toInt()}%',
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 10.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintSurface,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        langCode == 'en' ? 'Done' : 'مكتمل',
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 10.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  '${achievements?.countExamChaptersDone ?? 0}',
                                  style: AppTextStyles.cairoExtraBold(
                                    fontSize: 22,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppStrings.get('FinishedExams', langCode),
                                style: AppTextStyles.cairoBold(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Attendance Rate Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: AppDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.mintSurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fact_check_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppStrings.get('attendance_in_materials', langCode),
                            style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.orangeLight,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.orangeBorder),
                        ),
                        child: Text(
                          '${(achievements?.attendanceRate ?? 0).toStringAsFixed(1)}%',
                          style: AppTextStyles.cairoExtraBold(fontSize: 13, color: AppColors.orangeDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ((achievements?.attendanceRate ?? 0) / 100).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Study Materials Section Title
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
                  AppStrings.get('StudyMaterials', langCode),
                  style: AppTextStyles.cairoExtraBold(fontSize: 18, color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Study Materials List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: materials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                final material = materials[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.read<EduPortalViewModel>().setMaterial(
                            material.materialPk,
                            material.materialName,
                          );
                      Navigator.of(context).pushNamed(AppRoutes.portalMaterialNav);
                    },
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
                              color: AppColors.mintSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.mintBorder),
                            ),
                            child: const Center(
                              child: Icon(AppIcons.book, color: AppColors.primary, size: 24),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  material.materialName,
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      material.profName,
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
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
                              size: 12,
                              color: AppColors.textMuted,
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
        ),
      ),
    );
  }
}
