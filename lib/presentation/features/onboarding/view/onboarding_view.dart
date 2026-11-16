import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onFinish(OnboardingViewModel vm) async {
    await vm.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final isLast = viewModel.currentPage == viewModel.slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo_raster.webp',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  if (!isLast)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.mintSurface,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: const BorderSide(color: AppColors.mintBorder),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      ),
                      onPressed: () => _onFinish(viewModel),
                      child: Text(
                        langCode == 'en' ? 'Skip' : 'تخطي',
                        style: AppTextStyles.cairoBold(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 36),
                ],
              ),
            ),

            // Slides Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: viewModel.slides.length,
                onPageChanged: (idx) => viewModel.setPage(idx),
                itemBuilder: (ctx, index) {
                  final slide = viewModel.slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.borderSubtle,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Lottie.asset(
                            slide.lottieAsset,
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          AppStrings.get(slide.titleKey, langCode),
                          style: AppTextStyles.cairoExtraBold(
                            fontSize: 22,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.get(slide.bodyKey, langCode),
                          style: AppTextStyles.cairoMedium(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: viewModel.slides.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.orange,
                      dotColor: Color(0xFFCBD5E1),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                      spacing: 6,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    child: isLast
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.orange.withValues(alpha: 0.4),
                            ),
                            onPressed: () => _onFinish(viewModel),
                            icon: const Icon(AppIcons.forwardArrow, size: 18),
                            label: Text(
                              langCode == 'en' ? 'Get Started' : 'ابدأ الآن',
                              style: AppTextStyles.cairoBold(
                                fontSize: 15,
                                color: AppColors.white,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  AppIcons.forwardArrow,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
