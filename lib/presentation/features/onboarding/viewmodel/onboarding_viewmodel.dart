import 'package:flutter/material.dart';
import '../../../../data/datasources/local_datasource.dart';

class OnboardingItemModel {
  final String lottieAsset;
  final String titleKey;
  final String bodyKey;

  OnboardingItemModel({
    required this.lottieAsset,
    required this.titleKey,
    required this.bodyKey,
  });
}

class OnboardingViewModel with ChangeNotifier {
  final LocalDataSource localDataSource;

  int _currentPage = 0;

  OnboardingViewModel(this.localDataSource);

  int get currentPage => _currentPage;

  final List<OnboardingItemModel> slides = [
    OnboardingItemModel(
      lottieAsset: 'assets/lottie/raya.json',
      titleKey: 'onboarding_title_1',
      bodyKey: 'onboarding_text_1',
    ),
    OnboardingItemModel(
      lottieAsset: 'assets/lottie/hat.json',
      titleKey: 'onboarding_title_2',
      bodyKey: 'onboarding_text_2',
    ),
    OnboardingItemModel(
      lottieAsset: 'assets/lottie/books.json',
      titleKey: 'onboarding_title_3',
      bodyKey: 'onboarding_text_3',
    ),
  ];

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await localDataSource.markFirstOpenDone();
  }
}
