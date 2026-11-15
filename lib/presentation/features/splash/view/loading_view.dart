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
  const LoadingView({Key? key}) : super(key: key);

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().initApp();
    });
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
      backgroundColor: AppColors.mainC,
      body: Center(
        child: viewModel.status == SplashStatus.securityFailed
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(AppIcons.error, size: 80, color: AppColors.orange),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.get(viewModel.errorMessage ?? 'unknown_error', langCode),
                      style: AppTextStyles.cairoBold(fontSize: 16, color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.get('rayatxt', langCode),
                    style: AppTextStyles.cairoExtraBold(
                      fontSize: 28,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.get('slangInEdu', langCode),
                    style: AppTextStyles.cairoMedium(
                      fontSize: 16,
                      color: AppColors.hello,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const LoadingIndicatorWidget(color: AppColors.orange, size: 55),
                ],
              ),
      ),
    );
  }
}
