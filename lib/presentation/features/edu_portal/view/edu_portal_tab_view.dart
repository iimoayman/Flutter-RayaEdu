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
      onRefresh: () => homeVm.loadHomeData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Welcome & Profile Row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.mainC,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: student != null && student.photoUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Icon(AppIcons.person, color: Colors.white),
                            ),
                            errorWidget: (_, __, ___) => const CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Icon(AppIcons.person, color: Colors.white),
                            ),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            child: Icon(AppIcons.person, color: Colors.white),
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
                            fontSize: 13,
                            color: AppColors.hello,
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
                        Text(
                          '${AppStrings.get('stu_id', langCode)}: ${student?.code ?? '---'}',
                          style: AppTextStyles.cairoMedium(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Supabase Banners Carousel
            if (homeVm.banners.isNotEmpty) ...[
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: homeVm.banners.length,
                  itemBuilder: (ctx, index) {
                    final banner = homeVm.banners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: banner.img.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: banner.img,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Center(
                                  child: Text(
                                    AppStrings.get('portalOfRaya', langCode),
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 16,
                                      color: AppColors.mainC,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  AppStrings.get('portalOfRaya', langCode),
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 16,
                                    color: AppColors.mainC,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SmoothPageIndicator(
                  controller: _bannerController,
                  count: homeVm.banners.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.mainC,
                    dotColor: Colors.black26,
                    dotHeight: 6,
                    dotWidth: 6,
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
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.location);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mainC,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(AppIcons.location, color: AppColors.white, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.get('WhereIsIt', langCode),
                            style: AppTextStyles.cairoBold(
                              fontSize: 14,
                              color: AppColors.white,
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
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.qrScan);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(AppIcons.qr, color: AppColors.white, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.get('ScanQr', langCode),
                            style: AppTextStyles.cairoBold(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Attendance Rate Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.progressCardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.get('attendance_in_materials', langCode),
                        style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.black),
                      ),
                      Text(
                        '${(achievements?.attendanceRate ?? 0).toStringAsFixed(1)}%',
                        style: AppTextStyles.cairoExtraBold(fontSize: 15, color: AppColors.mainC),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ((achievements?.attendanceRate ?? 0) / 100).clamp(0.0, 1.0),
                      minHeight: 9,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mainC),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Study Materials Section Title
            Text(
              AppStrings.get('StudyMaterials', langCode),
              style: AppTextStyles.cairoExtraBold(fontSize: 18, color: AppColors.mainC),
            ),
            const SizedBox(height: 12),

            // Study Materials List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: materials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                final material = materials[index];
                return InkWell(
                  onTap: () {
                    context.read<EduPortalViewModel>().setMaterial(
                          material.materialPk,
                          material.materialName,
                        );
                    Navigator.of(context).pushNamed(AppRoutes.portalMaterialNav);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: AppDecorations.cardDecoration(context),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.mainC.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(AppIcons.book, color: AppColors.mainC, size: 28),
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
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                material.profName,
                                style: AppTextStyles.cairoMedium(
                                  fontSize: 13,
                                  color: AppColors.mainC,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(AppIcons.forwardArrow, color: AppColors.lightGray, size: 16),
                      ],
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
