import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../viewmodel/splash_viewmodel.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().initApp();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SplashViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    if (viewModel.status == SplashStatus.securityPassed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(viewModel.destinationRoute);
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryDark,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: viewModel.status == SplashStatus.securityFailed
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.orangeLight,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.orangeBorder),
                              ),
                              child: const Icon(
                                AppIcons.error,
                                size: 54,
                                color: AppColors.orange,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppStrings.get(
                                viewModel.errorMessage ?? 'unknown_error',
                                langCode,
                              ),
                              style: AppTextStyles.cairoBold(
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stylized Logo Container
                        Container(
                          width: 120,
                          height: 120,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: AppColors.orange.withValues(alpha: 0.25),
                                blurRadius: 36,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo_raster.webp',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // App Title
                        Text(
                          AppStrings.get('rayatxt', langCode),
                          style: AppTextStyles.cairoExtraBold(
                            fontSize: 26,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtitle Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppStrings.get('slangInEdu', langCode),
                            style: AppTextStyles.cairoMedium(
                              fontSize: 13,
                              color: AppColors.mintSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 56),

                        // Elegant Loader
                        const LoadingIndicatorWidget(
                          color: AppColors.orange,
                          size: 42,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
