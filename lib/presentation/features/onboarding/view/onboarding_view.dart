import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: viewModel.slides.length,
                  onPageChanged: (idx) => viewModel.setPage(idx),
                  itemBuilder: (ctx, index) {
                    final slide = viewModel.slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.mainC.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              slide.icon,
                              size: 70,
                              color: AppColors.mainC,
                            ),
                          ),
                          const SizedBox(height: 36),
                          Text(
                            AppStrings.get(slide.titleKey, langCode),
                            style: AppTextStyles.cairoExtraBold(
                              fontSize: 22,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.get(slide.bodyKey, langCode),
                            style: AppTextStyles.cairoMedium(
                              fontSize: 15,
                              color: AppColors.dGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: viewModel.slides.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.mainC,
                      dotColor: AppColors.lightGreen,
                      dotHeight: 9,
                      dotWidth: 9,
                      expansionFactor: 3,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (viewModel.currentPage < viewModel.slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await viewModel.completeOnboarding();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: AppColors.mainC,
                        shape: BoxShape.circle,
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
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
