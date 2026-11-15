import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/guest_viewmodel.dart';

class GuestView extends StatefulWidget {
  const GuestView({Key? key}) : super(key: key);

  @override
  State<GuestView> createState() => _GuestViewState();
}

class _GuestViewState extends State<GuestView> {
  final PageController _pageController1 = PageController();
  final PageController _pageController2 = PageController();

  @override
  void dispose() {
    _pageController1.dispose();
    _pageController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('guest_portal', langCode),
          style: AppTextStyles.cairoExtraBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banners Carousel 1
              if (viewModel.bannersOne.isNotEmpty) ...[
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController1,
                    itemCount: viewModel.bannersOne.length,
                    itemBuilder: (ctx, index) {
                      final banner = viewModel.bannersOne[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: banner.img.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: banner.img,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.mainC,
                                  child: Center(
                                    child: Text(
                                      AppStrings.get('rayatxt', langCode),
                                      style: AppTextStyles.cairoBold(
                                        fontSize: 18,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.mainC,
                                child: Center(
                                  child: Text(
                                    AppStrings.get('rayatxt', langCode),
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 18,
                                      color: AppColors.white,
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
                    controller: _pageController1,
                    count: viewModel.bannersOne.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.mainC,
                      dotColor: Colors.black26,
                      dotHeight: 7,
                      dotWidth: 7,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Academic Programs
              Text(
                langCode == 'en' ? 'Our Academic Programs' : 'البرامج الأكاديمية',
                style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.mainC),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.programs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (ctx, index) {
                    final prog = viewModel.programs[index];
                    return InkWell(
                      onTap: () {
                        viewModel.selectProgram(prog);
                        Navigator.of(context).pushNamed(AppRoutes.guestProgramDetails);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(14),
                        decoration: AppDecorations.cardDecoration(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(prog.icon, color: AppColors.mainC, size: 36),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.get(prog.titleKey, langCode),
                              style: AppTextStyles.cairoBold(
                                fontSize: 13,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // External Informational Links (Google Drive guides)
              _buildGuideCard(
                context,
                title: AppStrings.get('joinSystem', langCode),
                icon: AppIcons.book,
                onTap: () => _openUrl('https://drive.google.com/file/d/1h1AmKPW2hMGWgJKUVkHE0zCbmaTco8zS/view'),
              ),
              const SizedBox(height: 10),
              _buildGuideCard(
                context,
                title: AppStrings.get('MilitaryTxt', langCode),
                icon: AppIcons.statement,
                onTap: () => _openUrl('https://drive.google.com/file/d/1fw7uhONSjTlvHvruUlYMNZ8FydIoorEW/view'),
              ),
              const SizedBox(height: 10),
              _buildGuideCard(
                context,
                title: AppStrings.get('stu_guide', langCode),
                icon: AppIcons.userGuide,
                onTap: () => _openUrl('https://drive.google.com/file/d/1eqMIpm9SvQtyCk282gxA7iu5s4G5mtV7/view'),
              ),
              const SizedBox(height: 24),

              // Faculty & Crew Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.guestCrew);
                },
                icon: const Icon(AppIcons.group, color: AppColors.white),
                label: Text(
                  AppStrings.get('faculty_crew', langCode),
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainC,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDecorations.cardDecoration(context),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mainC, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.black),
              ),
            ),
            const Icon(AppIcons.forwardArrow, color: AppColors.lightGray, size: 16),
          ],
        ),
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
