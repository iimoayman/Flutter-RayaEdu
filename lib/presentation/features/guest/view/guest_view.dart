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
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/guest_viewmodel.dart';

class GuestView extends StatefulWidget {
  const GuestView({Key? key}) : super(key: key);

  @override
  State<GuestView> createState() => _GuestViewState();
}

class _GuestViewState extends State<GuestView> {
  final PageController _pageController1 = PageController();

  @override
  void dispose() {
    _pageController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banners Carousel
              if (viewModel.bannersOne.isNotEmpty) ...[
                SizedBox(
                  height: 155,
                  child: PageView.builder(
                    controller: _pageController1,
                    itemCount: viewModel.bannersOne.length,
                    itemBuilder: (ctx, index) {
                      final banner = viewModel.bannersOne[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderSubtle),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: banner.img.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: banner.img,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    decoration: const BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                    ),
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
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                  ),
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
                      activeDotColor: AppColors.orange,
                      dotColor: Color(0xFFCBD5E1),
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 3,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Academic Programs
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
                    langCode == 'en' ? 'Our Academic Programs' : 'البرامج الأكاديمية بالمعهد',
                    style: AppTextStyles.cairoExtraBold(fontSize: 18, color: AppColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.programs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (ctx, index) {
                    final prog = viewModel.programs[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          viewModel.selectProgram(prog);
                          Navigator.of(context).pushNamed(AppRoutes.guestProgramDetails);
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 165,
                          padding: const EdgeInsets.all(14),
                          decoration: AppDecorations.cardDecoration(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppColors.mintSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  prog.iconAsset,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppStrings.get(prog.titleKey, langCode),
                                style: AppTextStyles.cairoBold(
                                  fontSize: 13,
                                  color: AppColors.textDark,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Guides and Official Links
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    langCode == 'en' ? 'Guides & Regulations' : 'الأدلة واللوائح التعريفية',
                    style: AppTextStyles.cairoExtraBold(fontSize: 18, color: AppColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _buildGuideCard(
                context,
                title: AppStrings.get('joinSystem', langCode),
                icon: AppIcons.book,
                onTap: () => UrlLauncherHelper.launchExternalUrl(
                  context,
                  'https://drive.google.com/file/d/1h1AmKPW2hMGWgJKUVkHE0zCbmaTco8zS/view',
                  fallbackTitle: AppStrings.get('joinSystem', langCode),
                ),
              ),
              const SizedBox(height: 10),
              _buildGuideCard(
                context,
                title: AppStrings.get('MilitaryTxt', langCode),
                icon: AppIcons.statement,
                onTap: () => UrlLauncherHelper.launchExternalUrl(
                  context,
                  'https://drive.google.com/file/d/1fw7uhONSjTlvHvruUlYMNZ8FydIoorEW/view',
                  fallbackTitle: AppStrings.get('MilitaryTxt', langCode),
                ),
              ),
              const SizedBox(height: 10),
              _buildGuideCard(
                context,
                title: AppStrings.get('stu_guide', langCode),
                icon: AppIcons.userGuide,
                onTap: () => UrlLauncherHelper.launchStudentGuide(context),
              ),
              const SizedBox(height: 24),

              // Faculty & Crew Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.guestCrew);
                },
                icon: const Icon(AppIcons.group, color: AppColors.white, size: 20),
                label: Text(
                  AppStrings.get('faculty_crew', langCode),
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 16),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: AppDecorations.cardDecoration(context),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.mintSurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.textDark),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
